locals {
    ## CONDITIONS
    #   Configuration object containing boolean calculations that correspond
    #       to different deployment configurations.
    conditions                          = {
        # TODO: conditional calculations go here
    }

    ## <SERVICE> DEFAULTS
    #   These are platform defaults and should only be changed when the 
    #       platform itself changes.
    platform_defaults                   = {
        # TODO: platform defaults go here
    }
    
    ## CALCULATED PROPERTIES
    #   Properties that change based on deployment configurations
    platform                            = merge({
        # SERVICE SPECIFIC PLATFORM ARGS GO HERE, IF ANY.
    }, var.platform)
    
    tags                                = merge({
        # TODO: service specific tags go here
    }, module.platform.tags)


}