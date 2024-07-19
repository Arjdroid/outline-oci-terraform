variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
//variable "oracle_api_private_key_password" {}
variable "region" {}

variable "vcn_cidr_block" {}
variable "compartment_ocid" {}
variable "vcn_display_name" {}
variable "vcn_dns_label" {}

variable "subnet_cidr_block" {}
variable "subnet_display_name" {}
variable "subnet_dns_label" {}

variable "instance_shape" {}
variable "availability_domain_number" {}
variable "instance_display_name" {}
variable "instance_image_ocid" {}
//variable "instance_shape_config_memory_in_gbs" {}
//variable "instance_shape_config_ocpus" {}

variable "ssh_public_key" {}

// Actual OCI Outline Deployment Configuration

provider "oci" {
  tenancy_ocid          = var.tenancy_ocid
  user_ocid             = var.user_ocid
  fingerprint           = var.fingerprint
  private_key_path      = var.private_key_path
  //private_key_password  = var.oracle_api_private_key_password
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
      min = 1
      max = 65535
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

resource "oci_core_instance" "outline_instance" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = var.instance_display_name
  shape               = var.instance_shape

  create_vnic_details {
     subnet_id        = oci_core_subnet.outline_subnet.id
     display_name     = "OutlineVNIC"
     assign_public_ip = true
     hostname_label   = var.instance_display_name
  }

  /*shape_config {
    #Optional
    memory_in_gbs = var.instance_shape_config_memory_in_gbs
    ocpus = var.instance_shape_config_ocpus
  }*/


  source_details {
    source_type = "image"
    source_id   = var.instance_image_ocid[var.region]
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(file("./userdata/init.sh"))
  }

  timeouts {
    create = "60m"
  }
}

resource "oci_core_instance_console_connection" "outline_instance_console_connection" {
  #Required
  instance_id = oci_core_instance.outline_instance.id
  public_key  = var.ssh_public_key
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.compartment_ocid
  ad_number      = var.availability_domain_number
}

# Gets a list of vNIC attachments on the instance
data "oci_core_vnic_attachments" "instance_vnics" {
  compartment_id      = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domain.ad.name
  instance_id         = oci_core_instance.outline_instance.id
}

# Gets the OCID of the first (default) vNIC
data "oci_core_vnic" "instance_vnic" {
  vnic_id = lookup(data.oci_core_vnic_attachments.instance_vnics.vnic_attachments[0], "vnic_id")
}

output "connect_with_ssh" {
  value = oci_core_instance_console_connection.outline_instance_console_connection.connection_string
}

output "connect_with_vnc" {
  value = oci_core_instance_console_connection.outline_instance_console_connection.vnc_connection_string
}


// Credit to https://github.com/IAmStoxe/oracle-free-tier-wirehole for their main.tf file which this one is based upon
