resource "aws_vpc" "this" {
    cidr_block          = var.vpc.cidr_blocks[0]
    tags                = local.tags.default
}

resource "aws_vpc_ipv4_cidr_block_association" "this" {
    for_each            = local.secondary_cidrs
  
    vpc_id              = aws_vpc.this.id
    cidr_block          = each.value
}

resource "aws_subnet" "private" {
    for_each            = local.subnets.private

    vpc_id              = aws_vpc.vpc.id
    tags                = local.tags.private
    cidr_block          = each.value
}

resource "aws_subnet" "public" {
    for_each            = local.subnets.public

    vpc_id              = aws_vpc.vpc.id
    tags                = local.tags.private
    cidr_block          = each.value
}

resource "aws_subnet" "nat" {
    for_each            = local.subnets.nat

    vpc_id              = aws_vpc.vpc.id
    tags                = local.tags.private
    cidr_block          = each.value
}

resource "aws_subnet" "cni" {
    for_each            = local.subnets.cni

    vpc_id              = aws_vpc.vpc.id
    tags                = local.tags.private
    cidr_block          = each.value
}