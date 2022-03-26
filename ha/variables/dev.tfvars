resource_group_name = "RG_Group4_week3_20220321"
primary_location    = "West Europe"
secondary_location  = "North Europe"

app_service_plan_name = "x-p-9-01-apps-plan"
app_service_plan_sku = {
  tier = "Standard"
  size = "S1"
}

app_service_name                      = "high-availability-terraform-javaad"
app_service_application_insights_name = "high-availability-terraform-javaad"
cosmosdb_account_name                 = "high-availability-cosmosdb-javaad"
traffic_manager_profile_name          = "high-availability-terraform"
