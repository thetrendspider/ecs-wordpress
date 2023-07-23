
data "aws_vpc" "selected_vpc" {
  tags = {
    Name = "default"
  }

}

data "aws_subnets" "private_db_subnet" {

      filter {
        name   = "vpc-id"
        values = [data.aws_vpc.selected_vpc.id]
      }

      
}


resource "aws_lb" "ecs_alb" {
  name               = "my-ecs-alb"
  subnets            = data.aws_subnets.private_db_subnet.ids  # Replace with the subnet IDs where you want to deploy the ALB
  security_groups    = [aws_security_group.alb_sg.id]
  internal           = false

  tags = {
    Environment = var.env
  }
}

resource "aws_security_group" "alb_sg" {
  name_prefix = "my-ecs-alb-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "ecs_target_group" {
  name     = "my-ecs-target-group"
  port     = 80
  protocol = "HTTP"

  target_type = "ip"  # Set the target type to "ip" for compatibility with awsvpc network mode
  vpc_id   = data.aws_vpc.selected_vpc.id  # Replace with the actual VPC ID where the ALB and ECS cluster reside

  tags = {
    Environment = var.env
  }
}

resource "aws_lb_listener" "ecs_listener" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
  }
}
