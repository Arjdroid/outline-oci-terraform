variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "oracle_api_key_fingerprint" {}
variable "oracle_api_private_key_path" {}
variable "oracle_api_private_key_password" {}
variable "region" {}

provider "oci" {
  tenancy_ocid          = var.tenancy_ocid
  user_ocid             = var.user_ocid
  fingerprint           = var.oracle_api_key_fingerprint
  private_key_path      = var.oracle_api_private_key_path
  private_key_password  = var.oracle_api_private_key_password
  region                = var.region
}
