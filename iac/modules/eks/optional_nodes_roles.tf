## AWLS LOAD BALANCER CONTROLLER ADD ON
# resource "aws_iam_openid_connect_provider" "default" {
#   url = "https://oidc.eks.us-east-1.amazonaws.com/id/541017E78D158628DED92C7E60086097"

#   client_id_list = [
#     "266362248691-342342xasdasdasda-apps.googleusercontent.com",
#   ]

#   thumbprint_list = ["cf23df2207d99a74fbe169e3eba035e633b65d94"]
# }

# data "aws_iam_policy_document" "lb_controller_addon_policy" {
#   count = coalesce(var.cluster_settings.using_lb_controller_addon, false) ? 1 : 0

#   statement {
#     effect = "Allow"
#     actions = [
#       "iam:CreateServiceLinkedRole"
#     ]
#     resources = ["*"]
#     condition {
#       test = "StringEquals"
#       variable = "iam:AWSServiceName"
#       values = [
#         "elasticloadbalancing.amazonaws.com"
#       ]
#     }
#   }

#   statement {
#     effect = "Allow"
#     actions = [
#       "ec2:DescribeAccountAttributes",
#       "ec2:DescribeAddresses",
#       "ec2:DescribeAvailabilityZones",
#       "ec2:DescribeInternetGateways",
#       "ec2:DescribeVpcs",
#       "ec2:DescribeVpcPeeringConnections",
#       "ec2:DescribeSubnets",
#       "ec2:DescribeSecurityGroups",
#       "ec2:DescribeInstances",
#       "ec2:DescribeNetworkInterfaces",
#       "ec2:DescribeTags",
#       "ec2:GetCoipPoolUsage",
#       "ec2:DescribeCoipPools",
#       "elasticloadbalancing:DescribeLoadBalancers",
#       "elasticloadbalancing:DescribeLoadBalancerAttributes",
#       "elasticloadbalancing:DescribeListeners",
#       "elasticloadbalancing:DescribeListenerCertificates",
#       "elasticloadbalancing:DescribeSSLPolicies",
#       "elasticloadbalancing:DescribeRules",
#       "elasticloadbalancing:DescribeTargetGroups",
#       "elasticloadbalancing:DescribeTargetGroupAttributes",
#       "elasticloadbalancing:DescribeTargetHealth",
#       "elasticloadbalancing:DescribeTags"
#     ]
#     resources = ["*"]
#   }

#   statement {
#     effect = "Allow"
#     actions = [
#       "cognito-idp:DescribeUserPoolClient",
#       "acm:ListCertificates",
#       "acm:DescribeCertificate",
#       "iam:ListServerCertificates",
#       "iam:GetServerCertificate",
#       "waf-regional:GetWebACL",
#       "waf-regional:GetWebACLForResource",
#       "waf-regional:AssociateWebACL",
#       "waf-regional:DisassociateWebACL",
#       "wafv2:GetWebACL",
#       "wafv2:GetWebACLForResource",
#       "wafv2:AssociateWebACL",
#       "wafv2:DisassociateWebACL",
#       "shield:GetSubscriptionState",
#       "shield:DescribeProtection",
#       "shield:CreateProtection",
#       "shield:DeleteProtection"
#     ]
#     resources = ["*"]
#   }

#   statement {
#     effect = "Allow"
#     actions = [
#       "ec2:AuthorizeSecurityGroupIngress",
#       "ec2:RevokeSecurityGroupIngress",
#       "ec2:CreateSecurityGroup",
#     ]
#     resources = ["*"]
#   }
#   statement {
#     effect = "Allow"
#     actions = [
#       "ec2:CreateTags"
#     ]
#     resources = ["arn:aws:ec2:*:*:security-group/*"]
#     condition {
#       test = "StringEquals"
#       variable = "ec2:CreateAction"
#       values = [
#         "CreateSecurityGroup"
#       ]
#     }
#     condition {
#       test = "Null"
#       variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
#       values = [
#         "false"
#       ]
#     }
#   }
#   statement {
#     effect = "Allow"
#     actions = [
#       "ec2:CreateTags",
#       "ec2:DeleteTags"
#     ]
#     resources = ["arn:aws:ec2:*:*:security-group/*"]
#     condition {
#       test = "Null"
#       variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
#       values = [
#         "true"
#       ]
#     }
#     condition {
#       test = "Null"
#       variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
#       values = [
#         "false"
#       ]
#     }
#   }
#   statement {
#     effect = "Allow"
#     actions = [
#       "ec2:AuthorizeSecurityGroupIngress",
#       "ec2:RevokeSecurityGroupIngress",
#       "ec2:DeleteSecurityGroup"
#     ]
#     resources = ["*"]
#     condition {
#       test = "Null"
#       variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
#       values = [
#         "false"
#       ]
#     }
#   }
#   statement {
#     effect = "Allow"
#     actions = [
#       "elasticloadbalancing:CreateLoadBalancer",
#       "elasticloadbalancing:CreateTargetGroup"
#     ]
#     resources = ["*"]
#     condition {
#       test = "Null"
#       variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
#       values = [
#         "false"
#       ]
#     }
#   }
#   statement {
#     effect = "Allow"
#     actions = [
#       "elasticloadbalancing:CreateListener",
#       "elasticloadbalancing:DeleteListener",
#       "elasticloadbalancing:CreateRule",
#       "elasticloadbalancing:DeleteRule"
#     ]
#     resources = ["*"]
#   }
#   statement {
#     effect = "Allow"
#     actions = [
#       "elasticloadbalancing:AddTags",
#       "elasticloadbalancing:RemoveTags"
#     ]
#     resources = [
#       "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
#       "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
#       "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*"
#     ]
#     condition {
#       test = "Null"
#       variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
#       values = [
#         "true"
#       ]
#     }
#     condition {
#       test = "Null"
#       variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
#       values = [
#         "false"
#       ]
#     }
#   }
#   statement {
#     effect = "Allow"
#     actions = [
#       "elasticloadbalancing:AddTags",
#       "elasticloadbalancing:RemoveTags"
#     ]
#     resources = [
#       "arn:aws:elasticloadbalancing:*:*:listener/net/*/*/*",
#       "arn:aws:elasticloadbalancing:*:*:listener/app/*/*/*",
#       "arn:aws:elasticloadbalancing:*:*:listener-rule/net/*/*/*",
#       "arn:aws:elasticloadbalancing:*:*:listener-rule/app/*/*/*"
#     ]
#   }
#   statement {
#     effect = "Allow"
#     actions = [
#       "elasticloadbalancing:AddTags",
#     ]
#     resources = [
#       "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
#       "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
#       "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*"
#     ]
#     condition {
#       test = "Null"
#       variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
#       values = [
#         "false"
#       ]
#     }
#     condition {
#       test = "StringEquals"
#       variable = "elasticloadbalancing:CreateAction"
#       values = [
#         "CreateTargetGroup",
#         "CreateLoadBalancer"
#       ]
#     }
#   }
#   statement {
#     effect = "Allow"
#     actions = [
#       "elasticloadbalancing:ModifyLoadBalancerAttributes",
#       "elasticloadbalancing:SetIpAddressType",
#       "elasticloadbalancing:SetSecurityGroups",
#       "elasticloadbalancing:SetSubnets",
#       "elasticloadbalancing:DeleteLoadBalancer",
#       "elasticloadbalancing:ModifyTargetGroup",
#       "elasticloadbalancing:ModifyTargetGroupAttributes",
#       "elasticloadbalancing:DeleteTargetGroup"
#     ]
#   resources = ["*"]
#   condition {
#       test = "Null"
#       variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
#       values = [
#         "false"
#       ]
#     }
#   }
#   statement {
#     effect = "Allow"
#     actions = [
#       "elasticloadbalancing:RegisterTargets",
#       "elasticloadbalancing:DeregisterTargets"
#     ]
#     resources = ["arn:aws:elasticloadbalancing:*:*:targetgroup/*/*"]
#   }
#   statement {
#     effect = "Allow"
#     actions = [
#       "elasticloadbalancing:SetWebAcl",
#       "elasticloadbalancing:ModifyListener",
#       "elasticloadbalancing:AddListenerCertificates",
#       "elasticloadbalancing:RemoveListenerCertificates",
#       "elasticloadbalancing:ModifyRule"
#     ]
#     resources = ["*"]
#   }
# }

# resource "aws_iam_policy" "lb_controller_addon_policy" {
#   count = coalesce(var.cluster_settings.using_lb_controller_addon, false) ? 1 : 0

#   name   = "${var.project}-${local.account_id}-AWSLoadBalancerControllerIAMPolicy"
#   policy = data.aws_iam_policy_document.lb_controller_addon_policy[0].json
# }

# resource "aws_iam_role_policy_attachment" "lb_controller_addon_policy_attach" {
#   count = coalesce(var.cluster_settings.using_lb_controller_addon, false) ? 1 : 0

#   role       = aws_iam_role.eks_nodes_role.name
#   policy_arn = aws_iam_policy.lb_controller_addon_policy[0].arn
# }