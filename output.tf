output "azs" {
  description = "All the availability zones in the region"
  value       = data.aws_availability_zones.available_zones.names
}

output "ami_name" {
  description = "The AMI used to deploy the Django app"
  value       = data.aws_ami.amazon_linux_2023.name
}

output "load_balancer_ip" {
  description = "Frontend loadbalancer public IP"
  value       = aws_lb.backend.dns_name
}
