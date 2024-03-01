# Defining Variables

variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "oracle_api_key_fingerprint" {}
variable "oracle_api_private_key_path" {}
variable "oracle_api_private_key_password" {}
variable "region" {}

variable "vcn_cidr_block" {}
variable "compartment_ocid" {}
variable "vcn_display_name" {}
variable "vcn_dns_label" {}

# Actual OCI Outline Deployment Configuration

provider "oci" {
  tenancy_ocid          = var.tenancy_ocid
  user_ocid             = var.user_ocid
  fingerprint           = var.oracle_api_key_fingerprint
  private_key_path      = var.oracle_api_private_key_path
  private_key_password  = var.oracle_api_private_key_password
  region                = var.region
}

resource "oci_core_vcn" "my_vcn" {
  cidr_block     = var.vcn_cidr_block
  compartment_id = var.compartment_ocid
  display_name   = var.vcn_display_name
  dns_label      = var.vcn_dns_label
}
