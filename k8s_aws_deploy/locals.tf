locals {
  tags = {
    DeploymentMethod = "Terraform"
  }

  assets_path = {
    iam       = "./assets/iam"
    user_data = "./assets/user_data_scripts"
  }

  roles = {
    k8s1 = {
      name               = "k8s1-admin"
      description        = "full admin for k8s1 admin- testing"
      assume_role_policy = "${local.assets_path.iam}/trust_relationship.ec2.json"
      create_profile     = true
      attach_policies = {
        managed = {
          "AdministratorAccess" = "arn:aws:iam::aws:policy/AdministratorAccess"
        }
      }
    }
    k8s2 = {
      name               = "k8s2-admin"
      description        = "full admin for k8s2 admin- testing"
      assume_role_policy = "${local.assets_path.iam}/trust_relationship.ec2.json"
      create_profile     = true
      attach_policies = {
        managed = {
          "AdministratorAccess" = "arn:aws:iam::aws:policy/AdministratorAccess"
        }
      }
    }
  }

  security_groups = {
    operation_instance = {
      sg_name        = "operation_instance",
      sg_description = "operation_instance",
      cidr_block_rule = {
        ssh = {
          type        = "ingress", from_port = 22, to_port = 22, protocol = "TCP",
          cidr_blocks = ["0.0.0.0/0"], description = "Allow SSH from World"
        }
        outbound = {
          type        = "egress", from_port = 0, to_port = 0, protocol = "-1",
          cidr_blocks = ["0.0.0.0/0"], description = "Outbound all allowed"
        }
      }
    }
  }

  instance_types = {
    operation_instance = "t2.micro"
  }

  cluster_params = {
    name = "dev"
  }
}