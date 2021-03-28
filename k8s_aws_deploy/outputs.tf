output "ops_instance_configured" {
  value = "ssh -i ~/.ssh/${var.private_key_name} ec2-user@${module.ops_instance_configured.ec2_public_ip}"
}

output "ops_instance_unconfigured" {
  value = "ssh -i ~/.ssh/${var.private_key_name} ec2-user@${module.ops_instance_unconfigured.ec2_public_ip}"
}