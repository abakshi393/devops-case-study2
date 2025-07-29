output "instance_public_ip" {
  value = aws_eip.web_ip.public_ip
}
