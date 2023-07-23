# ecs_fargate_module/main.tf



resource "aws_ecs_cluster" "my_cluster" {
  name = var.cluster_name

  tags = {
    Environment = var.env
  }
}

resource "aws_ecs_task_definition" "my_first_task" {
  family                   = var.task_family
  container_definitions    = var.container_definitions
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = var.container_memory
  cpu                      = var.container_cpu
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  
  tags = {
    Environment = var.env
  }
  
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_security_group" "ecs_tasks" {
  name        = "wordpress-ecs-sg"
  description = "Allow inbound access in port 80 only"
  vpc_id      = data.aws_vpc.selected_vpc.id

  ingress {
	  protocol    = "tcp"
	  from_port   = 80
	  to_port     = 80
	  cidr_blocks = [
	    "0.0.0.0/0"]
  }

  egress {
	  protocol    = "-1"
	  from_port   = 0
	  to_port     = 0
	  cidr_blocks = [
	    "0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "my_first_service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_first_task.arn
  launch_type     = "FARGATE"
  desired_count   = var.desired_count

  network_configuration {
    subnets          = var.subnet_ids
    assign_public_ip = true # Providing our containers with public IPs
    security_groups = [aws_security_group.ecs_tasks.id]
    
  }

 
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
    container_name   = "my-container" # Replace with the name of your container within the task definition
    container_port   = 80  # Replace with the container port on which your application listens
  }

  tags = {
    Environment = var.env
  }
}
