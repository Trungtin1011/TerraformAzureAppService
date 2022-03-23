variable "location" {
  type				= string
  description	= "Azure Region for resources. Defaults to Southeast Asia."
  default			= "Southeast Asia"
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

