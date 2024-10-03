CONFIG_PATH="/root/bp-task/bp-eks-cluster"
cd /root/bp-task/bp-eks-cluster && terraform init && terraform plan && terraform apply -auto-approve
cd /root/bp-task/bp-acm-cert && terraform init && terraform plan && terraform apply -auto-approve && CERT_ARN=$(terraform output cert_arn)
sed -i 's|aws-load-balancer-ssl-cert: .*|aws-load-balancer-ssl-cert: $CERT_ARN|g' /root/bp-task/bp-k8s-app/*yaml
aws eks update-kubeconfig --region $(cat $CONFIG_PATH/config.yaml | yq .region | sed 's/"//g') --name "$(cat $CONFIG_PATH/config.yaml | yq .cluster_name| sed 's/"//g')-01"
kubectl get all -A
kubectl apply -f /root/bp-task/bp-k8s-app/
