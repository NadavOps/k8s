Thie lab is for testing reference and assimilation

This project is creating 2 machines with 2 different roles. \
from one of these machine eksctl is running and creating a cluster in a seperate vpc.

to run this project create terraform.tfvars file with:
```
aws_provider_main_region = <region of choise>
aws_credentials_profile  = <creds profile name>
private_key_name = <the private key file name>
public_key = <the public key string itself>
```


* after EKS is created the creating user is the admin. to add a role or user refer to the link: \
    https://aws.amazon.com/premiumsupport/knowledge-center/eks-api-server-unauthorized-error/