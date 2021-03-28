#!/bin/bash
### Set hostname
hostnamectl set-hostname unconfigured

### Update AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
awscli_path=$(which aws | rev | cut -c 5- | rev)
./aws/install --bin-dir $awscli_path --install-dir $awscli_path/aws-cli --update

### install eksctl: https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl $awscli_path

### install kubectl 1.16: https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.15/2020-11-02/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl $awscli_path

### Create k8s with eksctl
aws eks update-kubeconfig --name ${tf_eks_cluster_name} --region ${tf_region}