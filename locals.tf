locals {
    ## CONDITIONS
    #   Configuration object containing boolean calculations that correspond
    #       to different deployment configurations.
    conditions                          = {
        # TODO: conditional calculations go here
    }

    ## VPC DEFAULTS
    #   These are platform defaults and should only be changed when the 
    #       platform itself changes.
    platform_defaults                   = {
        private_subnet_block            = 4
        public_subnet_block             = 4
    }
    
    ## CALCULATED PROPERTIES
    #   Properties that change based on deployment configurations

    platforms                           = {
        default                         = merge({
            # SERVICE SPECIFIC PLATFORM ARGS GO HERE, IF ANY.
        }, var.platform)
        private                         = merge({
            subnet_type                 = "PRIVATE"
        })
        public                          = merge({
            subnet_type                 = "PUBLIC"
        })
    }
    
    secondary_cidrs                     = toset(try(slice(
                                            var.vpc.cidr_blocks, 
                                            1, 
                                            length(var.vpc.cidr_blocks)
                                        ), null))

     subnets                            = {
        private                         = { for index, az in var.vpc.availability_zones :
            az                          => {
                cidr_block              = cidrsubnet(
                                            var.vpc.cidr_blocks[0], 
                                            local.platform_defaults.private_subnet_block, 
                                            index
                                        )
            }
        }

        public                          = { for index, az in var.vpc.availability_zones :
            az                          => {
                cidr_block              = cidrsubnet(
                                            var.vpc.cidr_blocks[0], 
                                            local.platform_defaults.public_subnet_block, 
                                            index + length(var.vpc.availability_zones))
            }
        }
    }

    tags                                = { for key, value in module.platforms: 
                                            key => value.tags }

}