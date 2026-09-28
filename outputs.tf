output "instance_id" {
  description = "EC2 instance ID."
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Public IP address of the instance (null if no public IP)."
  value       = aws_instance.this.public_ip
}

output "private_ip" {
  description = "Private IP address of the instance."
  value       = aws_instance.this.private_ip
}

output "security_group_id" {
  description = "Security group protecting the instance."
  value       = aws_security_group.this.id
}

output "log_group_name" {
  description = "CloudWatch log group receiving /var/log/messages from the instance."
  value       = aws_cloudwatch_log_group.system.name
}

output "ssm_session_command" {
  description = "Command to open a shell on the instance without SSH."
  value       = "aws ssm start-session --target ${aws_instance.this.id} --region ${var.region}"
}
