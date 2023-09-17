## PostgreSQL Server Security Group and Rules

resource "aws_security_group" "database_sg" {
  name        = "JM-IM-PrivateSubnet-DBSever-SecurityGroup"
  description = "DataBase Main Server Security Group"
  vpc_id      = var.vpc_id

  lifecycle {
    # if changing 'name_prefix' properties.
    create_before_destroy = true
  }

  tags = merge({ "Name" = "JM-IM-PrivateSubnet-DBSever-SecurityGroup" }, local.tags)
}

# Security group rules

module "database_sg_rules" {
  source = "github.com/javier-mata/JM-IM-Modules/aws-securitygroup"
  sg_rules = {
    db_access = { description = "DB Access from Main WP Server", type = "ingress", from_port = "3306", to_port = "3306", protocol = "tcp", source_security_group_id = "${aws_security_group.main_wp_sg.id}" },
    https_out = { description = "HTTPS egress", type = "egress", from_port = "443", to_port = "443", protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    http_out2 = { description = "HTTP egress", type = "egress", from_port = "80", to_port = "80", protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
  }
  sg_id = aws_security_group.database_sg.id

}

## Main WP Server Security Group and Rules

resource "aws_security_group" "main_wp_sg" {
  name        = "JM-IM-PrivateSubnet-MainServer-SecurityGroup"
  description = "WordPress Main Server Security Group"
  vpc_id      = var.vpc_id

  lifecycle {
    # if changing 'name_prefix' properties.
    create_before_destroy = true
  }

  tags = merge({ "Name" = "JM-IM-PrivateSubnet-MainServer-SecurityGroup" }, local.tags)
}

# Security group rules

module "wp_main_sg_rules" {
  source = "github.com/javier-mata/JM-IM-Modules/aws-securitygroup"
  sg_rules = {
    http_access = { description = "HTTP Access from Public Load Balancer", type = "ingress", from_port = "80", to_port = "80", protocol = "tcp", source_security_group_id = "${aws_security_group.loadbalancer_sg.id}" },
    https_out   = { description = "HTTPS egress", type = "egress", from_port = "443", to_port = "443", protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    http_out2   = { description = "HTTP egress", type = "egress", from_port = "80", to_port = "80", protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    db_access   = { description = "DB Access to PostGreSQL Server", type = "egress", from_port = "3306", to_port = "3306", protocol = "tcp", source_security_group_id = "${aws_security_group.database_sg.id}" },
  }
  sg_id = aws_security_group.main_wp_sg.id

}


## Load Balancer Server Security Group and Rules

resource "aws_security_group" "loadbalancer_sg" {
  name        = "JM-IM-Public-LB-SecurityGroup"
  description = "PostGres Main Server Security Group"
  vpc_id      = var.vpc_id

  lifecycle {
    # if changing 'name_prefix' properties.
    create_before_destroy = true
  }

  tags = merge({ "Name" = "JM-IM-Public-LB-SecurityGroup" }, local.tags)
}

# Security group rules

module "loadbalancer_sg_rules" {
  source = "github.com/javier-mata/JM-IM-Modules/aws-securitygroup"
  sg_rules = {
    https_in  = { description = "HTTPS ingress from Public", type = "ingress", from_port = "443", to_port = "443", protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    https_out = { description = "HTTPS egress", type = "egress", from_port = "443", to_port = "443", protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    http_out2 = { description = "HTTP egress", type = "egress", from_port = "80", to_port = "80", protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    http_out  = { description = "HTTP egress to WP Main Server", type = "egress", from_port = "80", to_port = "80", protocol = "tcp", source_security_group_id = "${aws_security_group.main_wp_sg.id}" },
  }
  sg_id = aws_security_group.loadbalancer_sg.id

}