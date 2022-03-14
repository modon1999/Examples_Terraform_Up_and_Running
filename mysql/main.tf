#================== Provider ================
provider "aws" {
  region = "eu-central-1"
}

#================== Modules ================

module "mysql" {
  source           = "../../modules/data-stores/mysql"
  password_name_db = "/example"
  name_db          = "example"
  type_db          = "db.t2.micro"
  storage          = 10
  username_db      = "admin"
}
