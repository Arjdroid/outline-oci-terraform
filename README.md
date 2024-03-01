# Outline OCI Terraform

This repository contains Terraform Configurations for running Outline VPN on Oracle Cloud Infrastructure. The author does not endorse any particular uses of the contents of this project and has provided them 'as-is', and does not claim liabilities incurred by those that may use the contents of this project.

## Instructions

You must have an Oracle Cloud Infrastructure [OCI](https://cloud.oracle.com) Account, and [`terraform`](https://www.terraform.io/) installed on your system.

This project requires a `provider.tf` Terraform file in its root directory to function. The contents of this file are as follows:

```Terraform
provider "oci" {
  tenancy_ocid         = "your_tenancy_ocid"
  user_ocid            = "your_user_ocid"
  fingerprint          = "your_fingerprint"
  private_key_path     = "path/to/your/private_key.pem"
  region               = "your_region"
}
```

The contents to fill in this file may be acquired through following the instructions of Oracle Cloud's Documentation on Generating an API Signing Key: https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm and then copying the relevant fields from the 'Configuration file preview' provided on the OCI User Profile > Resources > API keys page https://cloud.oracle.com/identity/domains/my-profile/api-keys to your `provider.tf` file.
