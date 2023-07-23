data "template_file" "task_definition_template" {
  template = file("${path.module}/container-defination.json.tpl")
}

# main.tf in your main project

module "ecs_fargate" {
  source = "./ecs-fargate"  # Update the source path accordingly if your module is in a different directory
  cluster_name = "my-ecs-cluster"
  task_family = "my-ecs-task"
  subnet_ids = data.aws_subnets.private_db_subnet.ids
  container_definitions = data.template_file.container_definition_template.rendered
  container_memory = 512
  container_cpu = 256
  service_name = "my-ecs-service"
  desired_count = 2
  env = "poc"  # Replace with the desired environment tag value
}


