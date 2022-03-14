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

module "asg" {
  source             = "../../modules/cluster/asg-rolling-deploy"
  cluster_name       = var.cluster_name
  ami                = "ami-0f61af304b14f15fb"
  instance_type      = "t2.micro"
  min_size           = 1
  max_size           = 1
  enable_autoscaling = false
  subnet_ids         = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  user_data          = <<EOF
  #!bin/bash
  yum -y update
  yum -y install httpd
  PrivateIP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
  echo "<html><body bgcolor=blue><center><h2><p><font color=red>Web Server with: $PrivateIP Build by Terraform!</h2></center></body></html>" > /var/www/html/index.html
  sudo service httpd start
  chkconfig httpd on
EOF
}
