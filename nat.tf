#Define External IP 
resource "aws_eip" "siemens-nat" {
  vpc = true
}

resource "aws_nat_gateway" "siemens-nat-gw" {
  allocation_id = aws_eip.siemens-nat.id
  subnet_id     = aws_subnet.siemensvpc-public-1.id
  depends_on    = [aws_internet_gateway.siemens-gw]
}

resource "aws_route_table" "siemens-private" {
  vpc_id = aws_vpc.siemensvpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.siemens-nat-gw.id
  }

  tags = {
    Name = "siemens-private"
  }
}

# route associations private
resource "aws_route_table_association" "level-private-1-a" {
  subnet_id      = aws_subnet.siemensvpc-private-1.id
  route_table_id = aws_route_table.siemens-private.id
}

resource "aws_route_table_association" "level-private-1-b" {
  subnet_id      = aws_subnet.siemensvpc-private-2.id
  route_table_id = aws_route_table.siemens-private.id
}

resource "aws_route_table_association" "level-private-1-c" {
  subnet_id      = aws_subnet.siemensvpc-private-3.id
  route_table_id = aws_route_table.siemens-private.id
}