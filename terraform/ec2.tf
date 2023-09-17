## Database Main Server
module "database_main_server" {
  count            = 1
  source           = "github.com/javier-mata/JM-IM-Modules/aws-ec2-linux-public"
  subnet           = "subnet-0db471c5effd5407c"
  instance_type    = "t3.micro"
  ami_image_type   = "ami-01dd271720c1ba44f"
  instance_role    = "AWS_EC2_DefaultRole"
  root_volume_size = "50"
  security_group   = [aws_security_group.database_sg.id]
  key_name         = "JM-Terraform"                           
  kms_key_id       = ""
  default_region   = var.default_region
  userdata         = <<EOF
  #!/bin/bash
mkdir /tmp/ssm
cd /tmp/ssm
wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
sudo dpkg -i amazon-ssm-agent.deb
sudo systemctl enable amazon-ssm-agent
EOF

  tags   = merge({ "Name" = "IMJMDBSQLWP1" }, local.tags)
}

## WP Main Server
module "wordpress_main_server" {
  count            = 1
  source           = "github.com/javier-mata/JM-IM-Modules/aws-ec2-linux-public"
  subnet           = "subnet-00512ff5a642c37b1"
  instance_type    = "t3.micro"
  ami_image_type   = "ami-01dd271720c1ba44f"
  instance_role    = "AWS_EC2_DefaultRole"
  root_volume_size = "50"
  security_group   = [aws_security_group.main_wp_sg.id]
  key_name         = "JM-Terraform"                           
  kms_key_id       = ""
  default_region   = var.default_region
  userdata         = <<EOF
  #!/bin/bash
mkdir /tmp/ssm
cd /tmp/ssm
wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
sudo dpkg -i amazon-ssm-agent.deb
sudo systemctl enable amazon-ssm-agent
EOF
  tags   = merge({ "Name" = "IMJMMAINWP1" }, local.tags)
}

## Load Balancer Server

module "loadbalancer_server" {
  count            = 1
  source           = "github.com/javier-mata/JM-IM-Modules/aws-ec2-linux-public"
  subnet           = "subnet-00512ff5a642c37b1"
  instance_type    = "t3.nano"
  ami_image_type   = "ami-01dd271720c1ba44f"
  instance_role    = "AWS_EC2_DefaultRole"
  root_volume_size = "50"
  security_group   = [aws_security_group.loadbalancer_sg.id]
  key_name         = ""                           
  kms_key_id       = ""
  default_region   = var.default_region
  userdata         = <<EOF
  #!/bin/bash
mkdir /tmp/ssm
cd /tmp/ssm
wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
sudo dpkg -i amazon-ssm-agent.deb
sudo systemctl enable amazon-ssm-agent
EOF
  tags   = merge({ "Name" = "IMJMLBWP1" }, local.tags)
}