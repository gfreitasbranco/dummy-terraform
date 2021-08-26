output "linux_ip" {
  description = "IP of created EC2 instance"
  value = aws_instance.linux1.private_ip
}
