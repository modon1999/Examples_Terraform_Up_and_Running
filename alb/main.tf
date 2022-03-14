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

module "alb" {
  source   = "../../modules/networking/alb"
  subnets  = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  alb_name = "example"
}
