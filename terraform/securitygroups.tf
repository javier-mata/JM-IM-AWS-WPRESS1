## PostgreSQL Server Security Group and Rules

resource "aws_security_group" "postgres_sg" {
  name        = "JM-IM-PrivateSubnet-PGSever-SecurityGroup"
  description = "PostGres Main Server Security Group"
  vpc_id      = var.vpc_id

  lifecycle {
    # if changing 'name_prefix' properties.
    create_before_destroy = true
  }

  tags = merge({ "Name" = "JM-IM-PrivateSubnet-PGSever-SecurityGroup" }, var.tags)
}

# Security group rules

module "postgres_sg_rules" {
  source = "github.com/javier-mata/JM-IM-Modules/aws-securitygroup"
  sg_rules = {
    pg_access = { description = "PG Access from Main WP Server", type = "ingress", from_port = "5432", to_port = "5432", protocol = "tcp", source_security_group_id = "${aws_security_group.main_wp_sg.id}" },
    https_out = { description = "HTTPS egress", type = "egress", from_port = "443", to_port = "443", protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
  }
  sg_id = aws_security_group.postgres_sg.id

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

  tags = merge({ "Name" = "JM-IM-PrivateSubnet-MainServer-SecurityGroup" }, var.tags)
}

# Security group rules

module "wp_main_sg_rules" {
  source = "github.com/javier-mata/JM-IM-Modules/aws-securitygroup"
  sg_rules = {
    http_access = { description = "HTTP Access from Public Load Balancer", type = "ingress", from_port = "80", to_port = "80", protocol = "tcp", source_security_group_id = "${aws_security_group.loadbalancer_sg.id}" },
    https_out   = { description = "HTTPS egress", type = "egress", from_port = "443", to_port = "443", protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    pg_access   = { description = "PG Access to PostGreSQL Server", type = "egress", from_port = "5432", to_port = "5432", protocol = "tcp", source_security_group_id = "${aws_security_group.postgres_sg.id}" },
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

  tags = merge({ "Name" = "JM-IM-Public-LB-SecurityGroup" }, var.tags)
}

# Security group rules

module "loadbalancer_sg_rules" {
  source = "github.com/javier-mata/JM-IM-Modules/aws-securitygroup"
  sg_rules = {
    https_in  = { description = "HTTPS ingress from Public", type = "ingress", from_port = "443", to_port = "443", protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    https_out = { description = "HTTPS egress", type = "egress", from_port = "443", to_port = "443", protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    http_out  = { description = "HTTP egress to WP Main Server", type = "egress", from_port = "80", to_port = "80", protocol = "tcp", source_security_group_id = "${aws_security_group.main_wp_sg.id}" },
  }
  sg_id = aws_security_group.loadbalancer_sg.id

}