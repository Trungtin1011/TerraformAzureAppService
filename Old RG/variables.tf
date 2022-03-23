variable "location" {
  type				= string
  description	= "Azure Region for resources. Defaults to Southeast Asia."
  default			= "Southeast Asia"
}


variable "tags" {
  type    = map(string)
  default = {
    CreationDate = "2022-03-16" 
    ExpireDate   = "2022-03-26"
    Owner = "b.ngo@linkbynet.com"
    ModifyWith = "Terraform"
  }
}

