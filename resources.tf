resource "aws_vpc" "this" {
  lifecycle {
    ignore_changes            = [ tags ]
  }
  
  cidr_block                  = var.vpc.cidr_blocks[0]
  tags                        = local.tags.default
}

resource "aws_vpc_ipv4_cidr_block_association" "this" {
  for_each                    = local.secondary_cidrs

  vpc_id                      = aws_vpc.this.id
  cidr_block                  = each.value
}

resource "aws_internet_gateway" "this" {
  lifecycle {
    ignore_changes            = [ tags ]
  }
  
  vpc_id                      = aws_vpc.this.id
  tags                        = local.tags.default
}

resource "aws_eip" "nat" {
  count                       = var.vpc.enable_nat_gateway ? 1 : 0
  domain                      = "vpc"
}

resource "aws_nat_gateway" "this" {
  count                       = var.vpc.enable_nat_gateway ? 1 : 0
  depends_on                  = [ aws_internet_gateway.this ]

  lifecycle {
    ignore_changes            = [ tags ]
  }

  allocation_id               = aws_eip.nat[count.index].id
  subnet_id                   = aws_subnet.public[keys(local.subnets.public)[count.index]].id
  tags                        = local.tags.public
}

resource "aws_subnet" "public" {
  for_each                    = local.subnets.public

  lifecycle {
    ignore_changes            = [ tags ]
  }

  availability_zone           = each.key
  vpc_id                      = aws_vpc.this.id
  tags                        = local.tags.public
  cidr_block                  = each.value.cidr_block
}

resource "aws_route_table" "public" {
  lifecycle {
    ignore_changes            = [ tags ]
  }

  vpc_id                      = aws_vpc.this.id
  tags                        = local.tags.public
}

resource "aws_route" "public" {
  route_table_id              = aws_route_table.public.id
  destination_cidr_block      = "0.0.0.0/0"
  gateway_id                  = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each                    = aws_subnet.public

  subnet_id                   = each.value.id
  route_table_id              = aws_route_table.public.id
}

resource "aws_subnet" "private" {
  for_each                    = local.subnets.private

  lifecycle {
    ignore_changes            = [ tags ]
  }
  
  availability_zone           = each.key
  vpc_id                      = aws_vpc.this.id
  tags                        = local.tags.private
  cidr_block                  = each.value.cidr_block
}

resource "aws_route_table" "private" {
  count                       = var.vpc.enable_nat_gateway ? 1 : 0

  lifecycle {
    ignore_changes            = [ tags ]
  }

  vpc_id                      = aws_vpc.this.id
  tags                        = local.tags.private
}

resource "aws_route" "private_nat" {
  count                     = var.vpc.enable_nat_gateway ? 1 : 0

  route_table_id            = aws_route_table.private[count.index].id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = aws_nat_gateway.this[count.index].id
}

resource "aws_route_table_association" "private" {
  for_each                    = var.vpc.enable_nat_gateway ? aws_subnet.private : { }

  subnet_id                   = each.value.id
  route_table_id              = aws_route_table.private[0].id
}
