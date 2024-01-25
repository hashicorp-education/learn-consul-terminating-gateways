terraform init
terraform apply --auto-approve
# wait 15 minutes for build

# Connect to EKS
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw kubernetes_cluster_id)

# do this after RDS is created to import hashicups data: 
1. kubectl exec --stdin --tty deploy/postgres -- /bin/sh
2. su
3. apt update
4. apt install vim
5. vim dbexport.pgsql
6. copy in all the data from config/dbexport.pgsql
7. save the file
8. psql --host=learn-consul-7fqh.cvjehh8zzfhg.us-west-2.rds.amazonaws.com --port=5432 --username=postgres --dbname=products < dbexport.pgsql
9. (the password is password)

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

# Register AWS RDS as a service in Consul
consul services register config/external-service.json
OR
curl -k \
    --request PUT \
    --data @config/external-service.json \
    --header "X-Consul-Token: $CONSUL_HTTP_TOKEN" \
    $CONSUL_HTTP_ADDR/v1/catalog/register

# Create service defaults (this creates the virtual service)
kubectl apply --filename config/service-defaults.yaml

# Create ACL policy
consul acl policy create -name "managed-aws-rds-write-policy" -rules @config/write-acl-policy.hcl

# Obtain ID of terminating gateway role
consul acl role list -format=json | jq --raw-output '[.[] | select(.Name | endswith("-terminating-gateway-acl-role"))] | if (. | length) == 1 then (. | first | .ID) else "Unable to determine the role ID because there are multiple roles matching this name.\n" | halt_error end'

# Update terminating GW with new ACL policy
consul acl role update -id <role id> -policy-name managed-aws-rds-write-policy
consul acl role update -id f3831db4-b2b1-1af5-c312-a780d29cf244 -policy-name managed-aws-rds-write-policy

# Apply terminating gateway configuration
kubectl apply --filename config/terminating-gateway.yaml

# Create intention to allow communication from product-api to AWS RDS instance
kubectl apply --filename config/service-intentions.yaml

# Redeploy product-api with new managed AWS RDS transparent proxy address
kubectl delete -f hashicups/product-api.yaml && \
kubectl apply -f hashicups/product-api.yaml

# Go to API gateway URL and explore HashiCups
export CONSUL_APIGW_ADDR=http://$(kubectl get svc/api-gateway -o json | jq -r '.status.loadBalancer.ingress[0].hostname') && \
echo $CONSUL_APIGW_ADDR

# Check out Consul (optional)
echo $CONSUL_HTTP_ADDR && echo $CONSUL_HTTP_TOKEN