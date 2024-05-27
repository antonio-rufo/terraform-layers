# Initialisation

This layer is used to create the Compute resources.

# Pre-requisite

- AWS_ACCESS_KEYS and AWS_SECRET_ACCESS_KEYS are set as environment variables (link: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)
- Terraform version > 1.1.5 (version 1.3.7 suggested)


### Create

Update the `bucket` and `region` fields in the main.tf. (lines 20, 22, 34, and 36)

```bash
$ terraform init
$ terraform plan
$ terraform apply -auto-approve
```

### Destroy

```bash
$ terraform destroy --auto-approve
```

## Outputs

| Name | Description |
|------|-------------|
| ec2\_sg\_id | The ID of the EC2 Security Group. |
