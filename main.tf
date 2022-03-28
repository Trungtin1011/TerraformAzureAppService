# Resource Group
resource "azurerm_resource_group" "RG_Group4_week3_20220321" {
  name     = "RG_Group4_week3_20220321"
  location = var.RG-location
  tags = var.tags
}

################################ PRIMARY REGION - WEST EUROPE ################################
# Primary App Service Plan
resource "azurerm_app_service_plan" "cs3-primary-plan" {
  name                = "x-p-9-01-apps-plan"
  location            = var.primary_location
  resource_group_name = azurerm_resource_group.RG_Group4_week3_20220321.name
  tags                = var.tags
  kind                = "Linux"
  reserved            = true # must be true for Linux
  zone_redundant      = true

  sku {
    tier = "Premium"
    size = "P1V2"
  }
}

# Primary App Service 
resource "azurerm_app_service" "cs3-primary-app" {
  name                    = "x-p-9-01-app"
  location                = var.primary_location
  resource_group_name     = azurerm_resource_group.RG_Group4_week3_20220321.name
  app_service_plan_id     = azurerm_app_service_plan.cs3-primary-plan.id
  tags                		= var.tags

  source_control {
    repo_url           = "https://github.com/Trungtin1011/WP"
    branch             = "master"
    manual_integration = true
    use_mercurial      = false
  }
}

# Primary Azure MySQL 
resource "azurerm_mysql_server" "cs3-primary-sql" {
  name                = "x-p-9-01-mysqlserver"
  location            = var.primary_location
  resource_group_name = azurerm_resource_group.RG_Group4_week3_20220321.name

  administrator_login          = "group04"
  administrator_login_password = "Group@04"

  sku_name   = "GP_Gen5_2" 
  storage_mb = 5120 #smallest
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

# Primary Auto Scale
resource "azurerm_monitor_autoscale_setting" "cs3-primary-autoscale" {
  #count  = local.primary == "primary" ? 1 : 0
  name                = "x-p-9-01-autoscaleSetting"
  resource_group_name = azurerm_resource_group.RG_Group4_week3_20220321.name
  location            = var.primary_location
  target_resource_id  = azurerm_app_service_plan.cs3-primary-plan.id
  profile {
    name = "default"
    capacity {
      default = 1
      minimum = 1
      maximum = 10
    }
    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_app_service_plan.cs3-primary-plan.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 90
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_app_service_plan.cs3-primary-plan.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 10
      }
      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  }  
}
##############################################################################################


########################### AZURE DATABASE AND MYSQL FAILOVER GROUP ##########################

# Azure Database
resource "azurerm_mysql_database" "cs3-primary-db" {
  name                = "x-p-9-01-mysqldb"
  resource_group_name = azurerm_resource_group.RG_Group4_week3_20220321.name

  server_name         = azurerm_mysql_server.cs3-primary-sql.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_database" "cs3-second-db" {
  name                = "x-p-9-02-mysqldb"
  resource_group_name = azurerm_resource_group.RG_Group4_week3_20220321.name

  server_name         = azurerm_mysql_server.cs3-second-sql.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}


##############################################################################################


############################## SECONDARY REGION - NORTH EUROPE ##############################
# Secondary App Service Plan
resource "azurerm_app_service_plan" "cs3-second-plan" {
  name                = "x-p-9-02-apps-plan"
  location            = var.secondary_location
  resource_group_name = azurerm_resource_group.RG_Group4_week3_20220321.name
  tags                = var.tags
  kind                = "Linux"
  reserved            = true # must be true for Linux
  zone_redundant = true

  sku {
    tier = "Premium"
    size = "P1V2"
  }
}

# Secondary App Service 
resource "azurerm_app_service" "cs3-second-app" {
  name                    = "x-p-9-02-app"
  location                = var.secondary_location
  resource_group_name     = azurerm_resource_group.RG_Group4_week3_20220321.name
  tags                		= var.tags
  app_service_plan_id = azurerm_app_service_plan.cs3-second-plan.id

  source_control {
    repo_url           = "https://github.com/Trungtin1011/WP"
    branch             = "master"
    manual_integration = true
    use_mercurial      = false
  }
}

# Secondary Azure MySQL 
resource "azurerm_mysql_server" "cs3-second-sql" {
  name                = "x-p-9-02-mysqlserver"
  location            = var.secondary_location
  resource_group_name = azurerm_resource_group.RG_Group4_week3_20220321.name

  administrator_login          = "group04"
  administrator_login_password = "Group@04"

  sku_name   = "GP_Gen5_2" 
  storage_mb = 5120 #smallest
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

# Secondary Auto Scale
resource "azurerm_monitor_autoscale_setting" "cs3-second-autoscale" {
  name                = "x-p-9-02-autoscaleSetting"
  resource_group_name = azurerm_resource_group.RG_Group4_week3_20220321.name
  location            = var.secondary_location
  target_resource_id  = azurerm_app_service_plan.cs3-second-plan.id
  profile {
    name = "default"
    capacity {
      default = 1
      minimum = 1
      maximum = 10
    }
    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_app_service_plan.cs3-second-plan.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 90
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_app_service_plan.cs3-second-plan.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 10
      }
      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  }  
}
#############################################################################################

########################### TRAFFIC MANAGER FOR HIGH AVAILABILITY ###########################
resource "azurerm_traffic_manager_profile" "traffic_profile" {
  name                   = "x-p-9-01-traffic-profile"
  resource_group_name    = azurerm_resource_group.RG_Group4_week3_20220321.name
  traffic_routing_method = "Priority"

   dns_config {
    relative_name = "x-p-9-01-traffic-profile"
    ttl           = 100
  }

  monitor_config {
    protocol                     = "HTTPS"
    port                         = 443
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 10
    tolerated_number_of_failures = 2
  }
  }

resource "azurerm_traffic_manager_azure_endpoint" "primary_endpoint" {
  name               = "x-p-9-01-endpoint"
  profile_id         = azurerm_traffic_manager_profile.traffic_profile.id
  priority           = 1
  weight             = 100
  target_resource_id = azurerm_app_service.cs3-primary-app.id
}

resource "azurerm_traffic_manager_azure_endpoint" "secondary_endpoint" {
  name               = "x-p-9-02-endpoint"
  profile_id         = azurerm_traffic_manager_profile.traffic_profile.id
  priority           = 2
  weight             = 100
  target_resource_id = azurerm_app_service.cs3-second-app.id 
}

#############################################################################################