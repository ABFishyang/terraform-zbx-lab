locals {
  server_hostname = "${var.project_name}-server"

  agent_hostnames = {
    public-b  = "${var.project_name}-agent-public-b"
    private-a = "${var.project_name}-agent-private-a"
    private-b = "${var.project_name}-agent-private-b"
  }

  server_user_data = templatefile(
    "${path.module}/user_data/zabbix-server.sh.tftpl",
    {
      hostname          = local.server_hostname
      project_name      = var.project_name
      db_password       = var.zabbix_db_password
      enable_monitoring = var.enable_monitoring
      log_group_names   = module.monitoring.log_group_names
    }
  )

  agent_user_data = {
    for key, hostname in local.agent_hostnames :
    key => templatefile(
      "${path.module}/user_data/zabbix-agent.sh.tftpl",
      {
        hostname         = hostname
        zabbix_server_ip = var.server_private_ip
      }
    )
  }
}

resource "terraform_data" "configuration_guard" {
  input = {
    create_ec2_instances = var.create_ec2_instances
    enable_nat_gateway   = var.enable_nat_gateway
    enable_monitoring    = var.enable_monitoring
  }

  lifecycle {
    precondition {
      condition     = !var.create_ec2_instances || var.enable_nat_gateway
      error_message = "enable_nat_gateway must be true when create_ec2_instances is true because private agents require outbound internet access during bootstrap."
    }

    precondition {
      condition     = !var.enable_monitoring || var.create_ec2_instances
      error_message = "create_ec2_instances must be true when enable_monitoring is true."
    }
  }
}

module "network" {
  source = "./modules/network"

  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
}

module "security" {
  source = "./modules/security"

  project_name = var.project_name
  vpc_id       = module.network.vpc_id
  admin_cidr   = var.admin_cidr
}

module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
}

module "monitoring" {
  source = "./modules/monitoring"

  project_name       = var.project_name
  enable_monitoring  = var.enable_monitoring
  alarm_email        = var.alarm_email
  log_retention_days = var.log_retention_days

  depends_on = [terraform_data.configuration_guard]
}

module "compute" {
  source = "./modules/compute"

  project_name     = var.project_name
  create_instances = var.create_ec2_instances

  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids

  server_security_group_id  = module.security.server_security_group_id
  agent_security_group_id   = module.security.agent_security_group_id
  iam_instance_profile_name = module.iam.instance_profile_name

  server_instance_type       = var.server_instance_type
  agent_instance_type        = var.agent_instance_type
  server_root_volume_size    = var.server_root_volume_size
  agent_root_volume_size     = var.agent_root_volume_size
  enable_detailed_monitoring = var.enable_detailed_monitoring

  server_private_ip = var.server_private_ip
  agent_private_ips = var.agent_private_ips
  server_user_data  = local.server_user_data
  agent_user_data   = local.agent_user_data

  depends_on = [
    terraform_data.configuration_guard,
    module.network,
    module.security,
    module.iam,
    module.monitoring
  ]
}

module "alarms" {
  source = "./modules/alarms"

  project_name       = var.project_name
  enable_monitoring  = var.enable_monitoring
  server_instance_id = module.compute.server_instance_id
  sns_topic_arn      = module.monitoring.sns_topic_arn

  memory_alarm_threshold = var.memory_alarm_threshold
  disk_alarm_threshold   = var.disk_alarm_threshold
  alarm_period_seconds   = var.alarm_period_seconds
  evaluation_periods     = var.evaluation_periods
  datapoints_to_alarm    = var.datapoints_to_alarm

  depends_on = [
    terraform_data.configuration_guard,
    module.compute
  ]
}
