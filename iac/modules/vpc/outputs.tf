output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = try(aws_vpc.vpc[0].id, null)
}