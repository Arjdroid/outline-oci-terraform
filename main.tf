// Credit to https://github.com/IAmStoxe/oracle-free-tier-wirehole for their main.tf file which this one is based upon

// Defining Variables

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

// Actual OCI Outline Deployment Configuration

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
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_vcn.outline_vcn.id // Using the VCNID of the VCN generated in the previous resource
  display_name        = var.subnet_display_name
  dns_label           = var.subnet_dns_label
  route_table_id      = oci_core_vcn.outline_vcn.default_route_table_id
  dhcp_options_id     = oci_core_vcn.outline_vcn.default_dhcp_options_id // Reusing default DHCP options from VCN
  security_list_ids   = [oci_core_security_list.outline_security_list.id] // In square brackets because it's not made sequentially prior, I'm assuming, I do not know
}

resource "oci_core_internet_gateway" "outline_internet_gateway" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.outline_vcn.id
  display_name   = "OutlineInternetGateway"
}

resource "oci_core_default_route_table" "test_route_table" {
  manage_default_resource_id = oci_core_vcn.outline_vcn.default_route_table_id

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.outline_internet_gateway.id
  }
}

resource "oci_core_security_list" "outline_security_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.outline_vcn.id
  display_name   = "Outline Security List"

  // allow outbound tcp traffic on all ports
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  // allow inbound ssh traffic from a all ports to port
  ingress_security_rules {
    protocol  = "6" // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      source_port_range {
        min = 1
        max = 65535
      } // Not sure if this is still needed, but keeping it

      // These values correspond to the destination port range.
      min = 22
      max = 22
    }
  }

  // allow inbound TCP traffic on port 443 for Outline
  ingress_security_rules {
    protocol  = "6" // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      min = 443
      max = 443
    }
  }

  // allow inbound icmp traffic of a specific type
  ingress_security_rules {
    description = "icmp_inbound"
    protocol    = 1
    source      = "0.0.0.0/0"
    stateless   = false

    icmp_options {
      type = 3
      code = 4
    }
  }
}
