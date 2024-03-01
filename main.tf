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

variable "subnet_cidr_block" {}
variable "subnet_display_name" {}
variable "subnet_dns_label" {}
variable "vcn_id" {}  // Assuming you have this variable from VCN configuration

# Actual OCI Outline Deployment Configuration

provider "oci" {
  tenancy_ocid          = var.tenancy_ocid
  user_ocid             = var.user_ocid
  fingerprint           = var.oracle_api_key_fingerprint
  private_key_path      = var.oracle_api_private_key_path
  private_key_password  = var.oracle_api_private_key_password
  region                = var.region
}

resource "oci_core_vcn" "outline_vcn" {
  cidr_block     = var.vcn_cidr_block
  compartment_id = var.compartment_ocid
  display_name   = var.vcn_display_name
  dns_label      = var.vcn_dns_label
}

resource "oci_core_subnet" "outline_subnet" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  cidr_block          = var.subnet_cidr_block
  compartment_id      = var.compartment_ocid  // Reuse the compartment OCID variable from the VCN configuration
  vcn_id              = oci_core_vcn.outline_vcn.id // Using the VCN_ID of the VCN generated in the previous resource
  display_name        = var.subnet_display_name
  dns_label           = var.subnet_dns_label
  route_table_id      = oci_core_vcn.outline_vcn.default_route_table_id  // Assuming your VCN's name is outline_vcn
  dhcp_options_id     = oci_core_vcn.outline_vcn.default_dhcp_options_id // Reusing default DHCP options from VCN
}
