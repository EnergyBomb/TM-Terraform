variable "region" {
  description = "Ireland"
  default = "eu-west-1"
}

data "template_file" "Apache" {
  template = file("userdata/apache.tpl")
}

data "template_file" "SQL" {
  template = file("userdata/sql.tpl")
}