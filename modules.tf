module "platforms" {
  for_each              = local.platforms

  source                = "github.com/cumberland-terraform/network-vpc.git"

  platform              = each.value
}
