variable "platform" {
  description               = "Platform metadata configuration object."
  type                      = object({
    client                  = string
    environment             = string
  })
}

variable "vpc" {
  description               = "Virtual Private Cloud configuration object."

  type                      = object({
    enable_nat_gateway      = optional(bool, true)
    cidr_blocks             = list(string)
    availability_zones      = list(string)
  })

  validation {
    condition               = length(var.vpc.cidr_blocks) > 0
    error_message           = "`var.vpc.cidr_blocks` is empty. VPC requires atleast one CIDR block"
  }
}