output "lambda_function_role_id" {
  value = "${module.iam.lambda_function_role_id}"
}

output "s3_bucket" {
  value = "${module.s3.bucket}"
}

output "fqdn" {
  value = "${module.dns.fqdn}"
}
