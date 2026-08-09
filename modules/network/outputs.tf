output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "IPv4 CIDR of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "public_subnet_ids" {
  description = "Map of public subnet IDs"
  value       = { for key, subnet in aws_subnet.public : key => subnet.id }
}

output "private_subnet_ids" {
  description = "Map of private subnet IDs"
  value       = { for key, subnet in aws_subnet.private : key => subnet.id }
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "Map of private route table IDs"
  value       = { for key, table in aws_route_table.private : key => table.id }
}

output "nat_gateway_id" {
  description = "NAT Gateway ID, or null when disabled"
  value       = try(aws_nat_gateway.main[0].id, null)
}
