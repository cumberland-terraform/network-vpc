variable "platform" {
  description               = "Platform metadata configuration object. See [Platform Module] (https://source.mdthink.maryland.gov/projects/etm/repos/mdt-eter-platform/browse) for detailed information about the permitted values for each field."
  type                      = object({
    aws_region              = string 
    account                 = string
    acct_env                = string
    agency                  = string
    program                 = string
  })
}

variable "vpc" {
  description               = "Virtual Private Cloud configuration object. See [README] (https://source.mdthink.maryland.gov/projects/etm/repos/mdt-eter-core-network-vpc/browse) for detailed information about the permitted values for each field"
  type                      = object({

    cidr_block              = string
  })
}