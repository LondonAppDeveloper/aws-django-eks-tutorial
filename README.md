# Deploy Django to Kubernetes on AWS (EKS) Starter Code

Starting code for [How to Deploy Django to Kubernetes: Part 2](https://youtube.com/live/X_00g6HQwvI) YouTube live stream.

## What's covered?

 * How to setup Kubernetes (EKS) using Terraform
 * How to setup an RDS database that can be used from EKS
 * How to setup EFS for persistent data storage
 * How to Deploy a Django app which supports the Django admin and static media files.


## Resources

 * [Terraform .gitignore file template](https://github.com/github/gitignore/blob/main/Terraform.gitignore)
 * [Terraform VPC AWS module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
 * [Terraform RDS AWS module](https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/latest)
 * [Terraform security group AWS module](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest)
 * [Terraform EKS AWS module](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)
 * [Terraform IAM AWS modules](https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest)
 * [Kubernetes docs for Deploying the Dashboard UI](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/#deploying-the-dashboard-ui)
 * [Local Dashboard Proxy URL](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/)
 * [Docs for installing the Amazon EFS CSI driver](https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html)
