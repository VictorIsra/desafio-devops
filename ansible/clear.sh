
#!/bin/bash

# Lista os ALBs presentes na conta
lb_info=$(aws elbv2 describe-load-balancers --query "LoadBalancers[].[LoadBalancerArn, LoadBalancerName]" --output text)
echo $lb_info

# Deleta o(s) albs cujo nome tem o prefixo "k8s-default"
IFS=$'\n'
for lb_line in $lb_info; do
    lb_arn=$(echo "$lb_line" | awk '{print $1}')
    lb_name=$(echo "$lb_line" | awk '{print $2}')

    if [[ "$lb_name" == "k8s-default"* ]]; then
        echo "Deleting load balancer: $lb_name (ARN: $lb_arn)"
        aws elbv2 delete-load-balancer --load-balancer-arn $lb_arn
    fi
done

# Lista todos os security groups (sg) e suas descrições
group_info=$(aws ec2 describe-security-groups --query "SecurityGroups[].[GroupId, Description]" --output text)
echo $group_info

# Deleta os sgs que possuam a tag "[k8s]"
IFS=$'\n'
for line in $group_info; do
    id=$(echo "$line" | awk '{print $1}')
    description=$(echo "$line" | cut -f2-)

    if [[ "$description" == *"[k8s]"* ]]; then
        echo "Deleting security group: $id (Description: $description)"
        aws ec2 delete-security-group --group-id $id
    fi
done