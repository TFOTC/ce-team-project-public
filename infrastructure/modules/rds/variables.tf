variable "public_subnets" {
  type = set(string)
}

variable "vpc_id" {
  type = string
}

variable "db_password" {
  type    = string
  default = "password"
}
