locals {
  variables_shared = {
    profile = "default"
    stage = "lab"
    project = "desafio-devops"
  }

  variables_ecr = {
    image_tag_mutability = "MUTABLE"
  }

  variables_eks = {
    nodes_settings = {
      ami_type       = "AL2_x86_64" # AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64, CUSTOM
      capacity_type  = "ON_DEMAND"  # ON_DEMAND, SPOT
      disk_size      = 20
      instance_types = ["t2.medium"]
      scaling_config = [
        {
          desired_size = 2
          max_size     = 5
          min_size     = 1
        }
      ]
    }

    cluster_settings = {
      enabled_cluster_log_types = [
        "api", "audit", "authenticator", 
        "controllerManager", "scheduler"
      ]
      # using_lb_controller_addon = false
    }

    network_settings = {
      vpc = module.vpc.vpc_id
      nodegroup_subnets = module.vpc.private_subnets
      cluster_subnets = [module.vpc.private_subnets[0],module.vpc.public_subnets[1]]
    }

    eks_cluster_policy_statements = [
      {
        sid       = "SMAccess"
        actions   = ["secretsmanager:*"]
        effect    = "Allow"
        resources = [
          "*"
        ]
      }
    ]
    eks_nodes_policy_statements = [
      {
        sid       = "SMAccess"
        effect    = "Allow"
        actions   = ["secretsmanager:*"]
        resources = ["*"]
      },
      ## pode remover, ja tem na politica padrao pro node
      {
        sid     = "ECRAccess"
        effect  = "Allow"
        actions = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetAuthorizationToken"
        ]
        resources = ["*"]
      }
    ]
    eks_cluster_sg_statements = {
      ingress_rules = []
      egress_rules = []
    }
    eks_nodes_sg_statements = {
      ingress_rules = []
      egress_rules = []
    }
  }

  variables_vpc = {
    vpc_settings = {
      cidr_block = "172.4.0.0/16" # estudar pq isso n é valido: "172.2.15.0/16"
      enable_dns_hostnames = true
      enable_dns_support   = true
    }
    gateways_settings ={
      natgtw_ammount = 1 # melhorar. atualmente suporta só 1 ngtw kkk
      create_igtw = true
    }
    subnet_settings = {
      public_subnets = [
        {
          name = "publica-1"
          map_public_ip_on_launch = true
          subnet_cidr_bits = 8
        },
        {
          name = "publica-2"
          map_public_ip_on_launch = true
          subnet_cidr_bits = 8
        }
      ]
      private_subnets = [
        {
          subnet_cidr_bits = 8
          name = "privada-1"
        },
        {
          subnet_cidr_bits = 8
          name = "privada-2"
        }
      ]
    }
  }
  
}