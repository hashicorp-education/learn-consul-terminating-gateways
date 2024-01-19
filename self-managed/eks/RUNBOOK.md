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

# Update proxy defaults to enable proxy access logs
kubectl apply --filename config/proxy-defaults.yaml

# Redeploy HashiCups with updated proxies
kubectl rollout restart deployment --namespace default

# Go to API gateway URL and explore HashiCups
export CONSUL_APIGW_ADDR=http://$(kubectl get svc/api-gateway -o json | jq -r '.status.loadBalancer.ingress[0].hostname') && \
echo $CONSUL_APIGW_ADDR

# Go to Grafana URL and check out dashboards
export GRAFANA_ACCESS_LOGS_DASHBOARD=http://$(kubectl get svc/grafana --namespace observability -o json | jq -r '.status.loadBalancer.ingress[0].hostname')/d/access-logs-events-and-errors/ && echo $GRAFANA_ACCESS_LOGS_DASHBOARD

# Check out Consul (optional)
echo $CONSUL_HTTP_ADDR && echo $CONSUL_HTTP_TOKEN