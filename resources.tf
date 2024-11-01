resource "aws_vpc" "this" {
    cidr_block                  = var.vpc.cidr_blocks[0]
    tags                        = local.tags.default
}

resource "aws_vpc_ipv4_cidr_block_association" "this" {
    for_each                    = local.secondary_cidrs
  
    vpc_id                      = aws_vpc.this.id
    cidr_block                  = each.value
}

resource "aws_vpc_dhcp_options" "this" {
    domain_name                 = local.dhcp_options.domain_name
    domain_name_servers         = local.dhcp_options.domain_name_servers
    tags                        = local.tags.default
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
    vpc_id                      = aws_vpc.this.id
    dhcp_options_id             = aws_vpc_dhcp_options.this.id
}

resource "aws_subnet" "private" {
    for_each                    = local.subnets.private

    vpc_id                      = aws_vpc.this.id
    tags                        = local.tags.private
    cidr_block                  = each.value
}

resource "aws_subnet" "public" {
    for_each                    = local.subnets.public

    vpc_id                      = aws_vpc.this.id
    tags                        = local.tags.private
    cidr_block                  = each.value
}

resource "aws_subnet" "nat" {
    for_each                    = local.subnets.nat

    vpc_id                      = aws_vpc.this.id
    tags                        = local.tags.private
    cidr_block                  = each.value
}

resource "aws_subnet" "cni" {
    for_each                    = local.subnets.cni

    vpc_id                      = aws_vpc.this.id
    tags                        = local.tags.private
    cidr_block                  = each.value
}

resource "aws_route_table" "this" {
    vpc_id                      = aws_vpc.this.id
}

resource "aws_route" "this" {
    for_each                    = toset(local.routes)

    route_table_id              = aws_route_table.this.id
    destination_cidr_block      = try(each.value.destination_cidr_block, null)
    destination_prefix_list_id  = try(each.value.destination_prefix_list_id, null)
}

resource "aws_route_table_association" "this" {
    for_each                    = merge(
                                    aws_subnet.public, 
                                    aws_subnet.private, 
                                    aws_subnet.nat, 
                                    aws_subnet.cni
                                )

    subnet_id                   = each.value.id
    route_table_id              = aws_route_table.this.id
}