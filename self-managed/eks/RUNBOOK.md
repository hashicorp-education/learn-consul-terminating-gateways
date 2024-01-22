terraform init
terraform apply --auto-approve
# wait 15 minutes for build

# Connect to EKS
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw kubernetes_cluster_id)

# Ensure all services are up and running successfully
kubectl get pods --namespace consul && kubectl get pods --namespace observability && kubectl get pods --namespace default

# Set environment variables
export CONSUL_HTTP_TOKEN=$(kubectl get --namespace consul secrets/consul-bootstrap-acl-token --template={{.data.token}} | base64 -d) && \
export CONSUL_HTTP_ADDR=https://$(kubectl get services/consul-ui --namespace consul -o jsonpath='{.status.loadBalancer.ingress[0].hostname}') && \
export CONSUL_HTTP_SSL_VERIFY=false

# Notice that Consul services exist
consul catalog services

# Update Helm chart
consul-k8s upgrade -config-file=helm/consul-v2-terminating-gw.yaml

# Get the AWS RDS private DNS address
terraform output -raw aws_rds_endpoint

# Put private DNS address in config/service-defaults.yaml and save the file

# Create service defaults
kubectl apply --filename config/service-defaults.yaml

# Create ACL policy
consul acl policy create -name "managed-aws-rds-write-policy" -rules @config/write-acl-policy.hcl

# Obtain ID of terminating gateway role
consul acl role list -format=json | jq --raw-output '[.[] | select(.Name | endswith("-terminating-gateway-acl-role"))] | if (. | length) == 1 then (. | first | .ID) else "Unable to determine the role ID because there are multiple roles matching this name.\n" | halt_error end'

# Update terminating GW with new ACL policy
consul acl role update -id <role id> -policy-name managed-aws-rds-write-policy
consul acl role update -id 337d317d-41b5-c2f0-0ecd-6624616814af -policy-name managed-aws-rds-write-policy

# Apply terminating gateway configuration
kubectl apply --filename config/terminating-gateway.yaml

# Create intention to allow communication from product-api to AWS RDS instance
kubectl apply --filename config/service-intentions.yaml

# TROUBLESHOOTING CONTAINER
kubectl exec --stdin --tty deploy/public-api -- /bin/sh

# Redeploy product-api with new managed AWS RDS transparent proxy address
kubectl delete -f hashicups/product-api.yaml && \
kubectl apply -f hashicups/product-api.yaml

# Go to API gateway URL and explore HashiCups
export CONSUL_APIGW_ADDR=http://$(kubectl get svc/api-gateway -o json | jq -r '.status.loadBalancer.ingress[0].hostname') && \
echo $CONSUL_APIGW_ADDR

# Check out Consul (optional)
echo $CONSUL_HTTP_ADDR && echo $CONSUL_HTTP_TOKEN