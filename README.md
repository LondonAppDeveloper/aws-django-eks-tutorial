# Deploy Django to Kubernetes on AWS (EKS) Finished Code

Code for [How to Deploy Django to Kubernetes: Part 2](https://youtube.com/live/X_00g6HQwvI) YouTube live stream.

## What's covered?

 * How to setup Kubernetes (EKS) using Terraform
 * How to setup an RDS database that can be used from EKS
 * How to setup EFS for persistent data storage
 * How to Deploy a Django app which supports the Django admin and static media files.

## Requirements

 * [Terraform](https://developer.hashicorp.com/terraform/downloads?product_intent=terraform)
 * [aws-vault](https://github.com/99designs/aws-vault) for AWS authentication
 * [Docker](https://docs.docker.com/engine/install/) for building and pushing Docker images 
 * [Kubernetes CLI (kubectl)](https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/)
 * [Helm](https://helm.sh/docs/intro/quickstart/#install-helm)
 * [AWS account](https://aws.amazon.com/free/)

## Commands

Useful commands used in the tutorial.

### Terraform

Initialise terraform (required after adding new modules):
```sh
terraform init
```

Plan terraform (see what changes will be made to resources):
```sh
terraform plan
```

Apply Teraform (make changes to resources after confirmation):
```sh
terraform apply
```

Destroy resources in Terraform (removes everything after confirmation):
```sh
terraform destroy
```

### AWS CLI

Configure local EKS CLI to use cluster deployed by Terraform
```sh
aws eks --region $(terraform output -raw region) update-kubeconfig \
    --name $(terraform output -raw cluster_name)
```

 > NOTE: For Windows users, you may need to adjust the `$()` syntax. You can simply run `terraform output` to view all outputs and manually include them in the command.

Authenticate Docker with ECR

```sh
aws ecr get-login-password --region <REGION> | docker login --username AWS --password-stdin <ACCOUNT ID>.dkr.ecr.<REGION>.amazonaws.com
```

### Docker

Build and compress image in amd46 platform architecture:

```sh
docker build -t <REPO NAME>:<REPO TAG> --platform linux/amd64 --compress .
docker push <REPO NAME>:<REPO TAG>
```

### Kubernetes CLI (kubectl)

Get a list of running nodes in cluster:
```sh
kubectl get nodes
```

Apply recommended dashboard configuration:

```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
```

Create a cluster role binding:
```sh
kubectl create clusterrolebinding serviceaccounts-cluster-admin \
  --clusterrole=cluster-admin \
  --group=system:serviceaccounts
```

Create an auth token for a user (required to authenticate with the Kubernetes Dashboard:
```sh
kubectl create token admin-user --duration 4h -n kubernetes-dashboard
```

Start the kubernetes proxy (allows access to Kubernetes dashboard and API):

```sh
kubectl proxy
```

 > NOTE: The dashboard is accessible via this URL once the proxy is running: [http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/)

Apply kubernetes config (requires a `kustomization.yaml` file in the root of the target directory):
```sh
kubectl apply -k ./path/to/config
```

Execute a command on a running pod (for example, to get shell or create a superuser account with Django)

```sh
kubectl exec -it <POD NAME> sh
```


### Helm

Install EFS CSI driver in Kubernetes:

```sh
helm repo add aws-efs-csi-driver https://kubernetes-sigs.github.io/aws-efs-csi-driver/

helm upgrade -i aws-efs-csi-driver aws-efs-csi-driver/aws-efs-csi-driver \
    --namespace kube-system \
    --set image.repository=602401143452.dkr.ecr.eu-west-2.amazonaws.com/eks/aws-efs-csi-driver \
    --set controller.serviceAccount.create=true \
    --set controller.serviceAccount.name=efs-csi-controller-sa \
    --set "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"=<ROLE_ARN>
```

 > NOTE: The `<ROLE_ARN>` comes from the deployed resource in Terraform and can be viewed by running `terraform output efs_csi_sa_role`.
 > The `image.repository` value is different for each region and you can find the right one in the [Amazon container image repositories docs page](https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html).

## Resources

 * [Starting Point](https://github.com/LondonAppDeveloper/aws-django-eks-tutorial-starter) - this is the project we are starting from in the tutorial
 * [Terraform .gitignore file template](https://github.com/github/gitignore/blob/main/Terraform.gitignore)
 * [Terraform VPC AWS module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
 * [Terraform RDS AWS module](https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/latest)
 * [Terraform security group AWS module](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest)
 * [Terraform EKS AWS module](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)
 * [Terraform IAM AWS modules](https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest)
 * [Kubernetes docs for Deploying the Dashboard UI](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/#deploying-the-dashboard-ui)
 * [Local Dashboard Proxy URL](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/)
 * [Docs for installing the Amazon EFS CSI driver](https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html)
 * [ECR private registry authentication docs](https://docs.aws.amazon.com/AmazonECR/latest/userguide/registry_auth.html)
