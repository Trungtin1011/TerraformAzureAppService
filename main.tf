# Resource Group
resource "azurerm_resource_group" "RG_Group4_week3_20220321" {
  name     = "RG_Group4_week3_20220321"
  location = var.RG-location
  tags = var.tags
}

################################ WEST EUROPE ################################
# App Service Plan
resource "azurerm_app_service_plan" "cs3-plans" {
  name                = "gr4-x-p-9-apps-plan"
  location            = var.primary_location
  resource_group_name = azurerm_resource_group.RG_Group4_week3_20220321.name
  tags                = var.tags
  kind                = "Linux"
  reserved            = true # must be true for Linux
  zone_redundant      = true

  sku {
    tier = "Premium"
    size = "P2V2"
  }
}

# App Service 
resource "azurerm_app_service" "cs3-apps" {
  name                    = "gr4-x-p-9-app"
  location                = var.primary_location
  resource_group_name     = azurerm_resource_group.RG_Group4_week3_20220321.name
  app_service_plan_id     = azurerm_app_service_plan.cs3-plans.id
  tags                		= var.tags

  source_control {
    repo_url           = "https://github.com/Trungtin1011/WP"
    branch             = "master"
    manual_integration = true
    use_mercurial      = false
  }
}

# Azure MySQL 
resource "azurerm_mysql_server" "cs3-sql" {
  name                = "gr4-x-p-9-mysqlserver"
  location            = var.primary_location
  resource_group_name = azurerm_resource_group.RG_Group4_week3_20220321.name

  administrator_login          = "group04"
  administrator_login_password = "Group@04"

  sku_name   = "GP_Gen5_2" 
  storage_mb = 5120 #smallest
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = true
  infrastructure_encryption_enabled = true
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"

}

# Azure Database
resource "azurerm_mysql_database" "cs3-primary-db" {
  name                = "gr4-x-p-9-mysqldb"
  resource_group_name = azurerm_resource_group.RG_Group4_week3_20220321.name

  server_name         = azurerm_mysql_server.cs3-sql.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

# Auto Scale
resource "azurerm_monitor_autoscale_setting" "cs3-autoscale" {
  name                = "gr4-x-p-9-01-autoscaleSetting"
  resource_group_name = azurerm_resource_group.RG_Group4_week3_20220321.name
  location            = var.primary_location
  target_resource_id  = azurerm_app_service_plan.cs3-plans.id

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
        metric_resource_id = azurerm_app_service_plan.cs3-plans.id
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
        metric_resource_id = azurerm_app_service_plan.cs3-plans.id
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
##############################################################################
