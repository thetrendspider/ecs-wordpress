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
 

