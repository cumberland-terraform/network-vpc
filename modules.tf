module "platforms" {
  for_each              = local.platforms

  source                = "github.com/cumberland-terraform/platform.git"

  platform              = each.value
}
