# Outline OCI Terraform

This repository contains Terraform Configurations for running Outline VPN on Oracle Cloud Infrastructure. The author does not endorse any particular uses of the contents of this project and has provided them 'as-is', and does not claim liabilities incurred by those that may use the contents of this project.

## Instructions

This project requires a `provider.tf` Terraform file in its root directory to function. The contents of this file are as follows:

```
provider "oci" {
  tenancy_ocid         = "your_tenancy_ocid"
  user_ocid            = "your_user_ocid"
  fingerprint          = "your_fingerprint"
  private_key_path     = "path/to/your/private_key.pem"
  region               = "your_region"
}
```
