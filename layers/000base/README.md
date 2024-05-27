# Initialisation

This layer is used to setup the Network VPC.

# Pre-requisite

- AWS_ACCESS_KEYS and AWS_SECRET_ACCESS_KEYS are set as environment variables (link: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)
- Terraform version > 1.1.5 (version 1.3.7 suggested)

### Create

Update the `bucket` and `region` fields in the main.tf. (lines 20 and 22)

```bash
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```

### Destroy

```bash
$ terraform destroy --auto-approve
```

## Outputs for VPC

| Name | Description |
|------|-------------|
| vpc\_id | The ID of the VPC. |
| vpc\_cidr | The CIDR block of the VPC. |
| private\_subnets | List of IDs of private subnets. |
| public\_subnets | List of IDs of public subnets. |
| database\_subnets | List of IDs of private subnets. |
| database\_subnet\_group | ID of database subnet group. |
