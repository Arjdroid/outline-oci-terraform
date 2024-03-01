# Outline OCI Terraform

This repository contains Terraform Configurations for running Outline VPN on Oracle Cloud Infrastructure. The author does not endorse any particular uses of the contents of this project and has provided them 'as-is', and does not claim liabilities incurred by those that may use the contents of this project.

## Instructions

### Prerequisites

You must have an Oracle Cloud Infrastructure [OCI](https://cloud.oracle.com) Account, and [`terraform`](https://www.terraform.io/) installed on your system.
Additionally, you must configure SSH keys on your system, here is a guide to do so: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

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
vcn_display_name        = "OutlineVCN"
vcn_dns_label           = "outlinevcn"

```

The contents to fill in the oracle cloud platform part of this file are acquired through following the instructions on Oracle Cloud's Documentation to Generate an API Signing Key: https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm and then copying the relevant fields from the 'Configuration file preview' provided on the OCI User Profile > Resources > API keys page https://cloud.oracle.com/identity/domains/my-profile/api-keys to your `terraform.tfvars` file.

The networking details are configured as follows:

- `vcn_cidr_block`: This should be a valid CIDR block that you want to assign to your VCN (Virtual Cloud Network). If you don't know what a CIDR is, you may look it up, but `10.0.0.0/16` would likely suffice for a VCN of this scale.
- `compartment_ocid`: This is the OCID of the Oracle Cloud compartment where you want to create the VCN.
  - #### Finding Your Compartment OCID
    Your compartment's OCID (Oracle Cloud Identifier) is a unique identifier assigned by OCI to each of your compartments. Here's how to find it:
    1. Log in to the Oracle Cloud Console.
    2. Navigate to the hamburger menu in the upper left corner.
    3. Go to Identity & Security > Compartments.
    4. Find the compartment you want to use and click on it.
    5. You'll see the OCID at the top of the page or in the details pane; it's a long string starting with ocid1.compartment....
- `vcn_display_name`: This can be any name you choose to help identify the VCN in the OCI console.
- `vcn_dns_label`: This is a unique label that will be part of the DNS domain name for instances within the VCN. It must be unique across all VCNs in your tenancy.

After filling out all required details, you may deploy the project

## Deployment

```bash
$ terraform plan
$ terraform apply
```
