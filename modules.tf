module "platform" {
  source                = "git::ssh://git@source.mdthink.maryland.gov:22/etm/mdt-eter-platform.git?depth=1&ref=v1.0.20"

  platform              = local.platform
}
