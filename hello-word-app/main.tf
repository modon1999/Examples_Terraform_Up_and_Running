#================== Provider ================
provider "aws" {
  region = "eu-central-1"
}

#=============== Data ===============
data "aws_availability_zones" "available" {}
data "aws_vpc" "default" {
  # Data about default vpc
  default = true
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}


resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.available.names[1]
}

#================== Modules ================

module "hello-world-app" {
  source             = "../../modules/services/hello-world-app"
  subnet_ids         = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  environment        = "example"
  vpc_id             = data.aws_vpc.default.id
  password_name_db   = "/example"
  type_db            = "db.t2.micro"
  storage_db         = 10
  username_db        = "admin"
  server_port        = 80
  ami                = "ami-0f61af304b14f15fb"
  instance_type      = "t2.micro"
  min_size           = 1
  max_size           = 1
  enable_autoscaling = false
  custom_tags = {
    name = "EXAMPLE"
  }
  server_text       = "Example for Nikita!"
  health_check_type = "ELB"
}
