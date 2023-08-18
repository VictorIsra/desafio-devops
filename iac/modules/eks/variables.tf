variable "project" {
  type        = string
  description = ""
}

variable "stage" {
  type        = string
  description = ""
}

variable "cluster_settings" {
  type = object({
    enabled_cluster_log_types = optional(list(string)) # ["api", "audit"]
    # using_lb_controller_addon = optional(bool)
  })
}

variable "nodes_settings" {
  type = object({
    ami_type       = string # "AL2_x86_64" # AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64, CUSTOM
    capacity_type  = string # "ON_DEMAND"  # ON_DEMAND, SPOT
    disk_size      = number # 20
    instance_types = list(string) # ["t2.medium"]
    scaling_config = list(object({
      desired_size = number
      max_size     = number
      min_size     = number
    }))
  })
}

variable "network_settings" {
  type = object({
    vpc = string
    nodegroup_subnets = list(string)
    cluster_subnets = list(string)
  })
}

variable "eks_cluster_policy_statements" {
  type = list(object({
    sid       = string
    effect    = string
    actions   = list(string)
    resources = list(string)
    condition = optional(list(object({
      test = optional(string)
      variable = optional(string)
      values = optional(list(string))
    })))
  }))
}

variable "eks_nodes_policy_statements" {
  type = list(object({
    sid       = string
    effect    = string
    actions   = list(string)
    resources = list(string)
    condition = optional(list(object({
      test = optional(string)
      variable = optional(string)
      values = optional(list(string))
    })))
  }))
}

variable "eks_cluster_sg_statements" {
  type = object({
    ingress_rules = list(object({
      description      = optional(string)
      from_port        = optional(number)
      to_port          = optional(number)
      protocol         = optional(string)
      # ATENCAO: cidr_blocks e source_security_group_id sao mutualmente excludentes
      cidr_blocks              = optional(list(string))
      source_security_group_id =  optional(string) # sg que quero permitir acesso
    }))
    egress_rules = list(object({
      description      = optional(string)
      from_port        = optional(number)
      to_port          = optional(number)
      protocol         = optional(string)
      # ATENCAO: cidr_blocks e source_security_group_id sao mutualmente excludentes
      cidr_blocks              = optional(list(string))
      source_security_group_id =  optional(string) # sg que quero permitir acesso
    }))
  })
}

variable "eks_nodes_sg_statements" {
  type = object({
    ingress_rules = list(object({
      description      = optional(string)
      from_port        = optional(number)
      to_port          = optional(number)
      protocol         = optional(string)
      # ATENCAO: cidr_blocks e source_security_group_id sao mutualmente excludentes
      cidr_blocks              = optional(list(string))
      source_security_group_id =  optional(string) # sg que quero permitir acesso
    }))
    egress_rules = list(object({
      description      = optional(string)
      from_port        = optional(number)
      to_port          = optional(number)
      protocol         = optional(string)
      # ATENCAO: cidr_blocks e source_security_group_id sao mutualmente excludentes
      cidr_blocks              = optional(list(string))
      source_security_group_id =  optional(string) # sg que quero permitir acesso
    }))
  })
}