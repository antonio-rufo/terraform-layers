## Summary

This repo will create a 3 layer Demo environment.

## Basic Architecture

![Design](.github/img/Demo_Environment.png)

# Pre-requisite

- AWS_ACCESS_KEYS and AWS_SECRET_ACCESS_KEYS are set as environment variables (link: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)
- Terraform version > 1.1.5 (version 1.3.7 suggested)

### Step by Step deployment
* **Step 1: Clone the Repo**. This command will clone the repo and will change directory the recently cloned repo
```shell script
$ git clone https://github.com/antonio-rufo/terraform-layers.git
```

* **Step 2: Create a S3 bucket for remote state storage.** Update the `region` in the main.tf file to suit your testing. (line 5)

Create the resources:
```shell script
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```
Take note of the output for `state_bucket_id`. You'll need to update the `main.tf` on each layer with it. It is not yet possible to have the state bucket values interpolated.  


* **Step 3: Create the Base layer.** Update the `bucket` and `region` fields in the main.tf. (lines 20 and 22)

```shell script
$ cd ../layers/000base
$ vi main.tf
```
Create the resources:
```shell script
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```

* **Step 4: Create the Data layer.** Update the `bucket` and `region` fields in the main.tf. (lines 20, 22, 34, and 36)

```shell script
$ cd ../100data
$ vi main.tf
```

Create the resources:
```shell script
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```


* **Step 5: Create the Compute layer.** Update the `bucket` and `region` fields in the main.tf. (lines 20, 22, 34, 36, 45, and 47)

```shell script
$ cd ../200compute
$ vi main.tf
```

Create the resources:
```shell script
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```
