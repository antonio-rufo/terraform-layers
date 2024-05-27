# Initialisation

This layer is used to create a S3 bucket for remote state storage.

# Pre-requisite

- AWS_ACCESS_KEYS and AWS_SECRET_ACCESS_KEYS are set as environment variables (link: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)
- Terraform version > 1.1.5 (version 1.3.7 suggested)

### Create

Update the `region` in the main.tf file to suit your testing.

```bash
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```

### Destroy

```bash
$ terraform destroy --auto-approve
```

When prompted, check the plan and then respond in the affirmative.


## Outputs

| Name | Description |
|------|-------------|
| state\_bucket\_id | The ID of the bucket to be used for state files. |
| state\_bucket\_region | The region the state bucket resides in. |

