# ============================================
# network.tf
# ============================================

# 1. DATA SOURCES - Tham chiếu tài nguyên có sẵn
data "aws_vpc" "main" {
  id = "vpc-03a93cd09469290a0"
}

data "aws_subnet" "subnet_1" {
  id = "subnet-05cebfe3b5655a489"
}

data "aws_subnet" "subnet_2" {
  id = "subnet-0d5b891d766301198"
}

# 2. INTERNET GATEWAY
resource "aws_internet_gateway" "igw" {
  vpc_id = data.aws_vpc.main.id
  tags   = { Name = "webdt3-igw" }

  lifecycle {
    prevent_destroy = true
  }
}

# 3. ROUTE TABLE
resource "aws_route_table" "public_rt" {
  vpc_id = data.aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "webdt3-public-rt" }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = data.aws_subnet.subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

# 4. VPN RESOURCES
resource "aws_customer_gateway" "on_premise" {
  bgp_asn    = 65000
  ip_address = "203.0.113.1"
  type       = "ipsec.1"
  tags       = { Name = "webdt3-cgw" }
}

resource "aws_vpn_gateway" "vpn_gw" {
  vpc_id = data.aws_vpc.main.id
  tags   = { Name = "webdt3-vpn-gw" }
}

resource "aws_vpn_connection" "main" {
  vpn_gateway_id      = aws_vpn_gateway.vpn_gw.id
  customer_gateway_id = aws_customer_gateway.on_premise.id
  type                = "ipsec.1"
  static_routes_only  = true
  tags                = { Name = "webdt3-vpn-connection" }
}