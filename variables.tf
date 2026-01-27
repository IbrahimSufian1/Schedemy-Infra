variable "ami_id" {
  description = "The Golden AMI ID for SSchedemy Backend"
  type = string
  default = "ami-0bd34c6ba80e09e36"
}
variable "instance_type" {
  default = "t3.micro"
}
variable "key_name" {
  default = "SchedServer"

}
