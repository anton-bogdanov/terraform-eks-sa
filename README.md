# AWS EKS with Terraform: minimal example with Service Account for S3

This  project includes the following components:
- EKS version = `1.27` (this value is defined in `locals.tf`)
- Both public and private access endpoints enabled
- Terraform state file saved in a S3 bucket
- Required Terraform version is `>= 1.5`
- The following [Amazon EKS add-ons](https://docs.aws.amazon.com/eks/latest/userguide/eks-add-ons.html) are enabled:
  - enable_amazon_eks_coredns
  - enable_amazon_eks_kube_proxy
  - enable_amazon_eks_vpc_cni
  
## Prerequisites
- An AWS account
- A configured AWS CLI
- AWS IAM Authenticator
- [kubectl](https://learn.hashicorp.com/tutorials/terraform/eks#kubectl)
- Ensure that AWS credentials are available at: "~/.aws/credentials" on the host
```terraform
      [default]
      aws_access_key_id = <KEY>
      aws_secret_access_key = <SECRET>
      region = <REGION>
```
- Ensure that a S3 bucket for backend is created and has read write access by credentials set in the previous step. See the docs [here](https://www.terraform.io/docs/backends/types/s3.html)
- Set the bucket name in `backend.tf`

## Setup cluster

Run the following commands to set up the cluster:

```terraform
# Initialize Terraform
terraform init
# Review the planned actions prior applying (before you enter "yes")
terraform apply
# Configure kubectl
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)
```

## Run a sample pod with S3 access

Run the following commands to create a Service Account, a pod using it and verifying S3 access:

```
# Get S3 Role ARN
terraform output -raw eks_s3_role_arn
# Replace it in the sample YAML (if GNU Sed is not available, simple replace placeholder SARoleARN with output from previous step)
sed -i 's/SARoleARN/<value from previous step output>/' ./pod_w_serviceaccount.yaml
# Create Service Account and pod
kubectl apply -f pod_w_serviceaccount.yaml
# List S3 buckets in the AWS account
kubectl exec my-app-test -n default -- aws s3 ls
```

## Things that were omitted

- Private connectivity to EKS cluster API
- VPC S3 endpoint
- More fine-grained policy for accessing S3 bucket
- Environment separation (e.g. using TF workspaces)
- Certain essential EKS addons (metrics-server, ebs driver, secret store driver, etc)