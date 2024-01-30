terraform init
terraform apply --auto-approve
# wait 15 minutes for build

# Connect to EKS
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw kubernetes_cluster_id)

# Run the AWS Lambda function to import HashiCups DB data: 

# Ensure all services are up and running successfully
kubectl get pods --namespace consul && kubectl get pods --namespace default

# Set environment variables
## Check out Daniele's GS on VMs tutorial to find the API version of this
export CONSUL_HTTP_TOKEN=$(kubectl get --namespace consul secrets/consul-bootstrap-acl-token --template={{.data.token}} | base64 -d) && \
export CONSUL_HTTP_ADDR=https://$(kubectl get services/consul-ui --namespace consul -o jsonpath='{.status.loadBalancer.ingress[0].hostname}') && \
export CONSUL_HTTP_SSL_VERIFY=true && \
kubectl get --namespace consul secrets/consul-ca-cert -o json | jq -r '.data."tls.crt"' | base64 -d > ca.crt && \
export CONSUL_CACERT=ca.crt && \
export CONSUL_TLS_SERVER_NAME=server.dc1.consul

# Notice that Consul services exist
consul catalog services

# Update Helm chart
consul-k8s upgrade -config-file=helm/consul-v2-terminating-gw.yaml

# Get the AWS RDS private DNS address
terraform output -raw aws_rds_endpoint

# Put private DNS address in config/external-service.json and save the file

# Register managed-aws-rds as a service in Consul
consul services register config/external-service.json
OR
curl -k \
    --request PUT \
    --data @config/external-service.json \
    --header "X-Consul-Token: $CONSUL_HTTP_TOKEN" \
    $CONSUL_HTTP_ADDR/v1/catalog/register

# Create service defaults for managed-aws-rds (this creates the virtual service in Consul)
kubectl apply --filename config/service-defaults.yaml

# Create ACL policy (this allows TGW to communicate with managed-aws-rds)
consul acl policy create -name "managed-aws-rds-write-policy" -rules @config/write-acl-policy.hcl

# Obtain the ID of the TGW role (USE ENVIRONMENT VARIABLE HERE INSTEAD OF DEPENDING ON COPY/PASTE)
consul acl role list -format=json | jq --raw-output '[.[] | select(.Name | endswith("-terminating-gateway-acl-role"))] | if (. | length) == 1 then (. | first | .ID) else "Unable to determine the role ID because there are multiple roles matching this name.\n" | halt_error end'

# Attach the new ACL policy to the TGW role
consul acl role update -id $TGW_ACL_ROLE_ID -policy-name managed-aws-rds-write-policy
consul acl role update -id 4eea10a8-c873-592b-1ac3-44b750edb70d -policy-name managed-aws-rds-write-policy

# Apply TGW configuration (this links managed-aws-rds to TGW)
kubectl apply --filename config/terminating-gateway.yaml

# Create an intention (this allows communication from product-api to managed-aws-rds)
kubectl apply --filename config/service-intentions.yaml

# Explore hashicups/product-api.yaml to see the database configuration string
# Redeploy product-api with the managed-aws-rds.virtual.consul address
kubectl delete -f hashicups/product-api.yaml && \
kubectl apply -f hashicups/product-api.yaml

# Go to API gateway URL and explore HashiCups
export CONSUL_APIGW_ADDR=http://$(kubectl get svc/api-gateway -o json | jq -r '.status.loadBalancer.ingress[0].hostname') && \
echo $CONSUL_APIGW_ADDR

# Check out Consul (optional)
echo $CONSUL_HTTP_ADDR && echo $CONSUL_HTTP_TOKEN