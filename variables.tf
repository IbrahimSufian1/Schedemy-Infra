variable "ami_id" {
  description = "The Golden AMI ID for SSchedemy Backend"
  type = string
  default = "ami-0b39875d661541e13"
}
variable "instance_type" {
  default = "t3.micro"
}
variable "key_name" {
  default = "SchedServer"

}

