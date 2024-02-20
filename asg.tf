# Create a Load Balancer
resource "aws_lb" "siemens_load_balancer" {
  name               = "siemens-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-siemens.id]
  subnets            = [
    aws_subnet.siemensvpc-public-1.id,
    aws_subnet.siemensvpc-public-2.id
  ]

  enable_deletion_protection        = false  
  enable_cross_zone_load_balancing  = true

  tags = {
    Name = "siemens_load_balancer"
  }
}

# Create a Target Group
resource "aws_lb_target_group" "siemens-target-group" {
  name     = "siemens-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.siemensvpc.id

  health_check {
    path     = "/"
    protocol = "HTTP"
  }

  tags = {
    Name = "siemens-target-group"
  }
}

resource "aws_lb_listener" "siemens_listener" {
  load_balancer_arn = aws_lb.siemens_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.siemens-target-group.arn
  }
}

# Attach Load Balancer and Target Group to Auto Scaling Group
resource "aws_autoscaling_attachment" "siemens_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.siemens_auto_scaling_group.name
  lb_target_group_arn   = aws_lb_target_group.siemens-target-group.arn
}



# Create an Auto Scaling Group
resource "aws_launch_configuration" "siemens_launch_config" {
  name = "siemens-launch-config"
  image_id                   = "ami-06b72b3b2a773be2b"        
  instance_type              = "t2.micro"                    

 security_groups             = [aws_security_group.allow-siemens-ssh.id, aws_security_group.http-siemens.id]
   associate_public_ip_address = true
  key_name                    = "learningwithmanish"
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              echo "this is $(hostname)" > /var/www/html/index.html
              systemctl start httpd
              systemctl enable httpd
              EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "siemens_auto_scaling_group" {
  desired_capacity     = 2
  max_size             = 5
  min_size             = 1
  launch_configuration = aws_launch_configuration.siemens_launch_config.id
 vpc_zone_identifier       = [
    aws_subnet.siemensvpc-private-1.id,
    aws_subnet.siemensvpc-private-2.id
   
  ]


  force_delete         = true 
  tag {
    key                 = "Name"
    value               = "siemens-auto-scaling-group"
    propagate_at_launch = true
  }
}







