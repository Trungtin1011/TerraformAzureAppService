variable "rg-name" {
  type = string
  default = "RG_Group4_week3_20220321"
}

variable "RG-location" {
  type				= string
  description	= "Azure Region for resources. Defaults to Southeast Asia."
  default			= "Southeast Asia"
}

variable "serv-location" {
  type = string
  default = "Australia Central"
}

variable "primary_location" {
  type        = string
  description = "The primary region that the resources will be deployed into"
  default = "West Europe"
}

variable "secondary_location" {
  type        = string
  description = "The primary region that the resources will be deployed into"
  default = "North Europe"
}

variable "tags" {
  type    = map(string)
  default = {
    CreationDate = "2022-03-21"
    ExpireDate = "2022-04-05"
    Owner = "ja.dang@linkbynet.com"
    ModifyWith = "Terraform"
  }
}

variable "is_primary_deployment" {
  type        = number
  description = "Is this the primary deployment? (yes = 1, no = 0)"
}

# variable "one_two" {
#     type = bool
#     description = "This is for mysql database"
# }