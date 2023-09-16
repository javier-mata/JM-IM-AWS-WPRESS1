resource "aws_instance" "EC2_Instance" {
  ami                    = var.ami_image_type
  instance_type          = var.instance_type
  subnet_id              = var.subnet
  iam_instance_profile   = var.instance_role
  vpc_security_group_ids = ["${var.security_group}"]
  key_name               = var.key_name
  user_data              = var.userdata
  # root disk
  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp2"
    delete_on_termination = true
    encrypted             = true
    kms_key_id            = var.kms_key_id
  }
  # extra disk
  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_size           = var.add_volume_size
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
    kms_key_id            = var.kms_key_id
  }
  metadata_options {
    instance_metadata_tags      = "enabled"
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = "32"
  }
  tags = var.tags

  volume_tags = {
    Backup = "${var.backup}" # Will be used by backup_plan
  }
}