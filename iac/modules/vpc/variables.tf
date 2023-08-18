variable "project" {
  type        = string
  description = ""
}

variable "stage" {
  type        = string
  description = ""
}

variable "vpc_settings" {
  type = object({
    cidr_block = string
    custom_vpc_reference = optional(string)
    enable_dns_hostnames = bool
    enable_dns_support   = bool
  })
}

variable "gateways_settings" {
  type = object({
    natgtw_ammount = number
    custom_natgtw_reference = optional(string)
    custom_igtw_reference = optional(string)
    create_igtw = bool
  })
}

variable "subnet_settings" {
  type = object({
    public_subnets = list(object({
      name = string
      cidr_block = optional(string) # util somente se startup_mode = false
      map_public_ip_on_launch = bool
      subnet_cidr_bits = number # qts bits vou usar como rede extendida. por exemplo. vpc /16 com subnet_cird_brts = 8 gerará uma rede /24
    }))
    private_subnets = list(object({
      name = string
      cidr_block = optional(string)
      subnet_cidr_bits = number # qts bits vou usar como rede extendida. por exemplo. vpc /16 com subnet_cird_brts = 8 gerará uma rede /24
    }))
  })
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    "Project"     = "TerraformEKSWorkshop"
    "Environment" = "Development"
    "Owner"       = "Visra"
  }
}