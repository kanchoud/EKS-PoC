provider "aws" {
  region = local.config.region
  access_key = local.config.aws_access_key 
  secret_key = local.config.aws_secret_key 
}

data "aws_availability_zones" "available" {}

locals {
  config = yamldecode(file("config.yaml"))
#
 # tags = {
  #  Example    = local.tags
 # }
}


resource "aws_acm_certificate" "self_signed" {
  certificate_body = file(local.config.tls_cert)         # Path to your self-signed certificate
  private_key      = file(local.config.tls_key)         # Path to your private key

  tags = {
    Name = "SelfSignedCertificate"
  }
}

output "cert_arn" {
  value = aws_acm_certificate.self_signed.arn
}
