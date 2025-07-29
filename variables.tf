variable "platform" {
  description               = "Platform metadata configuration object."
  type                      = object({
    client                  = string
    environment             = string
  })
}

variable "vpc" {
  description               = "Virtual Private Cloud configuration object. See [README] (https://source.mdthink.maryland.gov/projects/etm/repos/mdt-eter-core-network-vpc/browse) for detailed information about the permitted values for each field"

  type                      = object({
    cidr_blocks             = list(string)
    availability_zones      = list(string)
  })

  validation {
    condition               = length(var.vpc.cidr_blocks) > 0
    error_message           = "`var.vpc.cidr_blocks` is empty. VPC requires atleast one CIDR block"
  }
}