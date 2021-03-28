provider "aws" {
  region  = var.aws_provider_main_region
  profile = var.aws_credentials_profile
}

module "security_groups" {
  source           = "git@github.com:NadavOps/terraform.git//aws/security_groups"
  for_each         = local.security_groups
  sg_name          = each.value.sg_name
  sg_description   = each.value.sg_description
  vpc_id           = tolist(data.aws_vpcs.vpcs.ids)[0]
  cidr_block_rules = contains(keys(each.value), "cidr_block_rule") ? each.value.cidr_block_rule : {}
  source_sg_rules  = contains(keys(each.value), "source_sg_rules") ? each.value.source_sg_rules : {}
  self_sg_rules    = contains(keys(each.value), "self_sg_rules") ? each.value.self_sg_rules : {}
}

module "roles" {
  source                         = "git@github.com:NadavOps/terraform.git//aws/iam_role"
  for_each                       = local.roles
  role_name                      = each.value.name
  role_description               = each.value.description
  force_detach_policies          = true
  create_profile                 = each.value.create_profile
  trust_relationship_policy_path = each.value.assume_role_policy
  path                           = "/"
  tags                           = {}

  aws_managed_policies    = contains(keys(each.value.attach_policies), "managed") ? each.value.attach_policies.managed : {}
  custom_managed_policies = contains(keys(each.value.attach_policies), "custom") ? each.value.attach_policies.custom : {}
}

resource "aws_key_pair" "ssh_key_pair" {
  key_name   = var.private_key_name
  public_key = var.public_key
}

module "ops_instance_configured" {
  source                              = "git@github.com:NadavOps/terraform.git//aws/ec2"
  ami                                 = data.aws_ami.amazon_linux_2.id
  instance_type                       = local.instance_types.operation_instance
  key_name                            = aws_key_pair.ssh_key_pair.key_name
  subnet_id                           = element(tolist(data.aws_subnet_ids.subnet_ids.ids), 0)
  vpc_security_group_ids              = [module.security_groups["operation_instance"].sg_id]
  iam_instance_profile                = module.roles["k8s1"].aws_iam_instance_profile_id
  associate_public_ip_address_enabled = true
  tags                                = merge(local.tags, { Name = "ops-configured" })
  user_data                           = "${local.assets_path.user_data}/operations_configured_instance.sh"
  user_data_variables = {
    tf_eks_cluster_name = local.cluster_params.name
    tf_region           = var.aws_provider_main_region
  }
}

module "ops_instance_unconfigured" {
  source                              = "git@github.com:NadavOps/terraform.git//aws/ec2"
  ami                                 = data.aws_ami.amazon_linux_2.id
  instance_type                       = local.instance_types.operation_instance
  key_name                            = aws_key_pair.ssh_key_pair.key_name
  subnet_id                           = element(tolist(data.aws_subnet_ids.subnet_ids.ids), 0)
  vpc_security_group_ids              = [module.security_groups["operation_instance"].sg_id]
  iam_instance_profile                = module.roles["k8s2"].aws_iam_instance_profile_id
  associate_public_ip_address_enabled = true
  tags                                = merge(local.tags, { Name = "unconfigured-ops" })
  user_data                           = "${local.assets_path.user_data}/unconfigured_operations_instance.sh"
  user_data_variables = {
    tf_eks_cluster_name = local.cluster_params.name
    tf_region           = var.aws_provider_main_region
  }
}