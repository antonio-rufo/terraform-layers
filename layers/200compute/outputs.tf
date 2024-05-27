###############################################################################
# Outputs - Security Groups
###############################################################################
output "ec2_sg_id" {
  description = "The ID of the EC2 Instance Security Group."
  value       = module.security_group_ec2.security_group_id
}