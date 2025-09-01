# Output IP
output "public_ip" {
  value       = aws_eip.app.public_ip
  description = "Public IP of EC2"
}
