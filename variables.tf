variable "ami_id" {
  description = "The Golden AMI ID for SSchedemy Backend"
  type = string
  default = "ami-032a0ed08b794e284"
}
variable "instance_type" {
  default = "t3.micro"
}
variable "key_name" {
  default = "SchedServer"
}