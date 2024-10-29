module "platform" {
  source                = "git::ssh://git@source.mdthink.maryland.gov:22/etm/mdt-eter-platform.git?depth=1"

  platform              = local.platform
}
