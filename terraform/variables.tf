variable "vpc_id" {
  description = "Value of the Name tag for the EC2 instance"
  default     = "vpc-0c9dccc916e79bc6a"
}
variable "default_region" {
  description = "Default Region"
  default     = "eu-west-1"
}
variable "tags" {
  description = "A mapping of tags to assign to security group"
  type        = map(string)
  default     = {}
}