# OpenWrt - Pipeline


## Requirements

In order to deploy the pipeline Terraform (version 1.0 or above) is required. 

Terraform can be Dowloaded and installed using this [link](https://www.terraform.io/downloads)

> AWS credentials should be already configured

## Pipeline 

Located at `pipeline` folder.

It holds the Terraform configuration for the pipeline. 

> The state of terraform is pushed to s3 and the concurrency is managed with DynamoDB (check the Deployment backend section) for more details on how the backend was created.


### Configuring the pipeline

Some variables are required in order to deploy the pipeline. 

These variables should be edited in the `terraform.tfvars` file 

```hcl
project_name      = "openwrt"
region            = "us-east-1"
deployment_bucket = "repo.onioniot.com"

stage_vars = {
  "stage_name" = {
    branch = "openwrt-22.03"
  }
}
```


- **region:** Region where to deploy the pipeline
- **project_name:** the project name that gonna act as prefix for all the created resources.
- **repository:** The Bucket holding the packages
- **stage_vars:** The code can be used to deploy multiple pipelines: example prod, beta etc...
    - Stage vars contains the Branch name for the pipeline


> The pipeline supports only having the same branch for all openwrt repositories

> Only the packahes repository will Trigger the pipeline: To change that refer to the `main.tf`  folder



### Deploying the pipeline

in the `pipeline folder` execute the following command:

```sh
terraform init 
terraform  workspace select "stage"
terraform apply
```

> if it's a new branch or stage: do `terraform  workspace new "stage"`

example: 

```sh
terraform init 
terraform  workspace new beta
terraform apply
```

and follow the instructions.

> After creating a new pipeline follow the link of the code star connection and activate the connection to github.


## Deployment Backend

Located at `deployment_backend` folder. 

This folder holds the terraform configuration for the backend on s3 using Dynamodb as a Lock table. 

> The state is pushed to the repository directly for the backend. and should be alawys be pushed whenever new changes are made on the backend. (eg: bucket name).

> Make sure not to delete the state file before destroying the pipeline environment, then the backend environment. 

> A general notice: The backend doesn't require any changes or new `apply` unless the whole project needs to be destroyed.


If at any case the backend is changed, make sure to update the `pipeline/provider.tf` file accordingly.

