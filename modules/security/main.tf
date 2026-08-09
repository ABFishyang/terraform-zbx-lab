resource "aws_security_group" "server" {
  name        = "${var.project_name}-server-sg"
  description = "Security group for the Zabbix server"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-server-sg"
  }
}

resource "aws_security_group" "agent" {
  name        = "${var.project_name}-agent-sg"
  description = "Security group for Zabbix monitored hosts"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-agent-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "server_http" {
  security_group_id = aws_security_group.server.id
  description       = "Zabbix web interface from administrator IP"
  cidr_ipv4         = var.admin_cidr
  ip_protocol       = "tcp"
  from_port         = var.http_port
  to_port           = var.http_port
}

resource "aws_vpc_security_group_ingress_rule" "server_trapper" {
  security_group_id            = aws_security_group.server.id
  description                  = "Active checks and trapper data from monitored hosts"
  referenced_security_group_id = aws_security_group.agent.id
  ip_protocol                  = "tcp"
  from_port                    = var.zabbix_server_port
  to_port                      = var.zabbix_server_port
}

resource "aws_vpc_security_group_ingress_rule" "agent_passive" {
  security_group_id            = aws_security_group.agent.id
  description                  = "Passive checks from the Zabbix server"
  referenced_security_group_id = aws_security_group.server.id
  ip_protocol                  = "tcp"
  from_port                    = var.zabbix_agent_port
  to_port                      = var.zabbix_agent_port
}

resource "aws_vpc_security_group_ingress_rule" "agent_icmp" {
  security_group_id            = aws_security_group.agent.id
  description                  = "ICMP checks from the Zabbix server"
  referenced_security_group_id = aws_security_group.server.id
  ip_protocol                  = "icmp"
  from_port                    = -1
  to_port                      = -1
}

resource "aws_vpc_security_group_egress_rule" "server_all_ipv4" {
  security_group_id = aws_security_group.server.id
  description       = "Allow all outbound IPv4 traffic"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "agent_all_ipv4" {
  security_group_id = aws_security_group.agent.id
  description       = "Allow all outbound IPv4 traffic"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
