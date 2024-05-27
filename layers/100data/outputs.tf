###############################################################################
# Outputs - Security Groups
###############################################################################
output "rds_sg_id" {
  description = "The ID of the RDS Security Group."
  value       = module.security_group_rds.security_group_id
}

###############################################################################
# Outputs - RDS Endpoint
###############################################################################
output "rds_endpoint" {
  description = "The RDS The connection endpoint."
  value       = module.rds.db_instance_endpoint
}
