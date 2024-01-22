# Set write access for external managed-aws-rds service
service "managed-aws-rds" {
  policy = "write"
  intentions = "read"
}