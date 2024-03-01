# Outline OCI Terraform

This repository contains Terraform Configurations for running Outline VPN on Oracle Cloud Infrastructure. The author does not endorse any particular uses of the contents of this project and has provided them 'as-is', and does not claim liabilities incurred by those that may use the contents of this project.

## Instructions

### Prerequisites

You must have an Oracle Cloud Infrastructure [OCI](https://cloud.oracle.com) Account, and [`terraform`](https://www.terraform.io/) installed on your system.

### Installation

After installing `terraform`, you clone this git repository onto your system and initialise the terraform project

```bash
$ git clone https://github.com/Arjdroid/outline-oci-terraform
$ cd outline-oci-terraform
$ terraform init
```

### Configuration

In order to run the project, you must configure it with the necessary details to run it.

This project requires a `terraform.tfvars` file in its root directory to function. The contents of this file are as follows:

```Terraform
tenancy_ocid                  = "ocid1.tenancy.oc1..exampleuniqueID"
user_ocid                     = "ocid1.user.oc1..exampleuniqueID"
oracle_api_key_fingerprint    = "ex:am:ple:__:fi:ng:er:pr:int"
oracle_api_private_key_path   = "/path/to/your/private_key.pem"
oracle_api_private_key_password = "yourPrivateKeyPassword"  # Leave empty if not set
region                        = "ex-example-1"

vcn_cidr_block          = "10.0.0.0/16"
compartment_ocid        = "ocid1.compartment.oc1..exampleuniqueID"
vcn_display_name        = "MyVCN"
vcn_dns_label           = "myvcn"

```

The contents to fill in the oracle cloud platform part of this file are acquired through following the instructions on Oracle Cloud's Documentation to Generate an API Signing Key: https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm and then copying the relevant fields from the 'Configuration file preview' provided on the OCI User Profile > Resources > API keys page https://cloud.oracle.com/identity/domains/my-profile/api-keys to your `terraform.tfvars` file.

The networking details are configured as follows:

- `vcn_cidr_block`: This should be a valid CIDR block that you want to assign to your VCN.
- `compartment_ocid`: This is the OCID of the compartment where you want to create the VCN.
- `vcn_display_name`: This can be any name you choose to help identify the VCN in the OCI console.
- `vcn_dns_label`: This is a unique label that will be part of the DNS domain name for instances within the VCN. It must be unique across all VCNs in your tenancy.

After filling out all required details, you may deploy the project

## Deployment

```bash
$ terraform plan
$ terraform apply
```
