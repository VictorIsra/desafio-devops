data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  count = var.vpc_settings.custom_vpc_reference == null ? 1 : 0
  
  cidr_block = var.vpc_settings.cidr_block

  enable_dns_hostnames = var.vpc_settings.enable_dns_hostnames
  enable_dns_support   = var.vpc_settings.enable_dns_support

  tags = {
    Name                                           = "${var.project}-vpc",
    "kubernetes.io/cluster/${var.project}-cluster" = "shared"
  }
}

# Redes publicas
resource "aws_subnet" "public" {
  count = length(var.subnet_settings.public_subnets)

  vpc_id            = var.vpc_settings.custom_vpc_reference == null ? aws_vpc.vpc[0].id : var.vpc_settings.custom_vpc_reference
  cidr_block        = cidrsubnet(var.vpc_settings.cidr_block, var.subnet_settings.public_subnets[count.index].subnet_cidr_bits, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name                                           = "${var.project}-${var.subnet_settings.public_subnets[count.index].name}-public-subnet"
    "kubernetes.io/cluster/${var.project}-cluster" = "shared"
    "kubernetes.io/role/elb"                       = 1
  }

  map_public_ip_on_launch = true
}

# Redes privadas
resource "aws_subnet" "private" {
  count = length(var.subnet_settings.private_subnets)

  vpc_id            = var.vpc_settings.custom_vpc_reference == null ? aws_vpc.vpc[0].id : var.vpc_settings.custom_vpc_reference
  cidr_block        = cidrsubnet(var.vpc_settings.cidr_block, var.subnet_settings.private_subnets[count.index].subnet_cidr_bits, length(var.subnet_settings.public_subnets) + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index % length(var.subnet_settings.private_subnets)]

  tags = {
    Name                                           = "${var.project}-${var.subnet_settings.private_subnets[count.index].name}-private-subnet"
    "kubernetes.io/cluster/${var.project}-cluster" = "shared"
    "kubernetes.io/role/internal-elb"              = 1
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igtw" {
  count = var.gateways_settings.create_igtw ? 1 : 0

  vpc_id = aws_vpc.vpc[0].id

  tags = {
    "Name" = "${var.project}-igw"
  }

  depends_on = [aws_vpc.vpc]
}

# NAT Elastic IP
resource "aws_eip" "nat_gtw" {
  count = var.gateways_settings.natgtw_ammount

  domain = "vpc"

  tags = {
    Name = "${var.project}-nat-gtw-ip"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gtw" {
  count = var.gateways_settings.natgtw_ammount

  allocation_id = aws_eip.nat_gtw[count.index].id
  subnet_id = aws_subnet.public[count.index % length(var.subnet_settings.public_subnets)].id

  tags = {
    Name = "${var.project}-nat-gtw-${count.index}"
  }
}

resource "aws_route_table" "public" {
  count = length(var.subnet_settings.public_subnets)

  vpc_id = var.vpc_settings.custom_vpc_reference == null ? aws_vpc.vpc[0].id : var.vpc_settings.custom_vpc_reference

  tags = {
    Name = "${var.project}-public-network-rt-${count.index}"
  }
}

resource "aws_route" "public_internet_gateway" {
  count = length(var.subnet_settings.public_subnets)

  route_table_id         = "${aws_route_table.public[count.index].id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.gateways_settings.custom_igtw_reference != null ? var.gateways_settings.custom_igtw_reference : "${aws_internet_gateway.igtw[0].id}"
}

# Tabela de roteamento e associacoes
resource "aws_route_table_association" "public" {
  count = length(var.subnet_settings.public_subnets)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

resource "aws_route_table" "private" {
  count = length(var.subnet_settings.private_subnets)

  vpc_id = var.vpc_settings.custom_vpc_reference == null ? aws_vpc.vpc[0].id : var.vpc_settings.custom_vpc_reference

  tags = {
    Name = "${var.project}-private-networks-rt-${count.index}"
  }
}

resource "aws_route" "private_nat_gateway" {
  count = length(var.subnet_settings.private_subnets)

  route_table_id         = "${aws_route_table.private[count.index].id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.gateways_settings.custom_natgtw_reference != null ? var.gateways_settings.custom_natgtw_reference : "${aws_nat_gateway.nat_gtw[count.index % var.gateways_settings.natgtw_ammount].id}"
}

resource "aws_route_table_association" "private" {
  count = length(var.subnet_settings.private_subnets)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}