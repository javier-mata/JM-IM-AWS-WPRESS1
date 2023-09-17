module "kms_encryption_key" {
  source      = "github.com/javier-mata/JM-IM-Modules/aws-kms"
  description = "JM IM Main Encryption Key"
  key_name    = "jm-im-aws-encryption-key"
  tags = merge({ "Name" = "jm-im-aws-encryption-key" }, local.tags) 
}