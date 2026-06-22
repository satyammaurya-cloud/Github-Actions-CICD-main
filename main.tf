resource "aws_vpc" "vpcss" {

  for_each = var.vpcs

  cidr_block = each.value.cidr_block
  tags       = each.value.tags
}

resource "aws_subnet" "subnetss" {

  for_each = var.subnets

  vpc_id     = aws_vpc.vpcss[each.value.vpc_id].id
  cidr_block = each.value.cidr_block
  tags       = each.value.tags
}