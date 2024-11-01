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
        # TODO: platform defaults go here
    }
    
    ## CALCULATED PROPERTIES
    #   Properties that change based on deployment configurations
    secondary_cidrs                     = toset(try(slice(
                                            var.vpc.cidr_blocks, 
                                            1, 
                                            length(var.vpc.cidr_blocks)
                                        ),null))

    platform                            = merge({
        # SERVICE SPECIFIC PLATFORM ARGS GO HERE, IF ANY.
    }, var.platform)
    
    prv_platform                        = merge({

    }, local.platform)

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
        nat                             = merge({
            subnet_type                 = "NETWORK ADDRESS TRANSLATION"
        })
        cni                             = merge({
            subnet_type                 = "CONTAINER NETWORK"
        })
    }

    subnets                             = {
        private                         = { for index, az in var.vpc.availability_zones: 
            az                          => {
                cidr_block              = "TODO: calculate"
            }
        }
        public                          = { for index, az in var.vpc.availability_zones: 
            az                          => {
                cidr_block              = "TODO: calculate"
            }
        }
        nat                             = { for index, az in var.vpc.availability_zones: 
            az                          => {
                cidr_block              = "TODO: CALCULATE"
            }
        }
        cni                             = { for index, az in var.vpc.availability_zones: 
            az                          => {
                cidr_block              = "TODO: calculate"
            }
        }
    }

    tags                                = { for key, value in module.platforms: 
                                            key => value.tags }

}