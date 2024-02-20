# Security Group for siemensvpc
resource "aws_security_group" "allow-siemens-ssh" {
  vpc_id      = aws_vpc.siemensvpc.id

  name        = "allow-siemens-ssh"
  description = "security group that allows ssh connection"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "http-siemens" {
  vpc_id      = aws_vpc.siemensvpc.id

  name        = "httpd-siemens"
  description = "security group that allows httpd to load balancer"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # cidr_blocks =  [aws_security_group.alb-siemens.id]
     cidr_blocks = ["10.0.1.0/24"]
  }
}

resource "aws_security_group" "alb-siemens" {
  vpc_id      = aws_vpc.siemensvpc.id

  name        = "alb-siemens"
  description = "security group that allows access to load balancer"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    # security_groups = [aws_security_group.http-siemens.id]
    cidr_blocks = ["0.0.0.0/0"]
  }
  }

