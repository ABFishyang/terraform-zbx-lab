data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

locals {
  agent_instances = {
    public-b = {
      subnet_id           = var.public_subnet_ids["b"]
      private_ip          = var.agent_private_ips["public-b"]
      associate_public_ip = true
    }
    private-a = {
      subnet_id           = var.private_subnet_ids["a"]
      private_ip          = var.agent_private_ips["private-a"]
      associate_public_ip = false
    }
    private-b = {
      subnet_id           = var.private_subnet_ids["b"]
      private_ip          = var.agent_private_ips["private-b"]
      associate_public_ip = false
    }
  }
}

resource "aws_instance" "server" {
  count = var.create_instances ? 1 : 0

  ami                         = data.aws_ssm_parameter.al2023_ami.insecure_value
  instance_type               = var.server_instance_type
  subnet_id                   = var.public_subnet_ids["a"]
  private_ip                  = var.server_private_ip
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.server_security_group_id]
  iam_instance_profile        = var.iam_instance_profile_name
  monitoring                  = var.enable_detailed_monitoring
  user_data                   = var.server_user_data
  user_data_replace_on_change = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.server_root_volume_size
    encrypted             = true
    delete_on_termination = true
  }

  volume_tags = {
    Name = "${var.project_name}-server-root"
  }

  tags = {
    Name = "${var.project_name}-server"
    Role = "zabbix-server"
  }

  lifecycle {
    ignore_changes = [ami]
  }
}

resource "aws_instance" "agent" {
  for_each = var.create_instances ? local.agent_instances : {}

  ami                         = data.aws_ssm_parameter.al2023_ami.insecure_value
  instance_type               = var.agent_instance_type
  subnet_id                   = each.value.subnet_id
  private_ip                  = each.value.private_ip
  associate_public_ip_address = each.value.associate_public_ip
  vpc_security_group_ids      = [var.agent_security_group_id]
  iam_instance_profile        = var.iam_instance_profile_name
  monitoring                  = var.enable_detailed_monitoring
  user_data                   = var.agent_user_data[each.key]
  user_data_replace_on_change = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.agent_root_volume_size
    encrypted             = true
    delete_on_termination = true
  }

  volume_tags = {
    Name = "${var.project_name}-agent-${each.key}-root"
  }

  tags = {
    Name = "${var.project_name}-agent-${each.key}"
    Role = "zabbix-agent"
  }

  lifecycle {
    ignore_changes = [ami]
  }
}
