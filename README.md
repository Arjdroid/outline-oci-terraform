# Outline OCI Terraform

This repository contains Terraform Configurations for running Outline VPN on Oracle Cloud Infrastructure. The author does not endorse any particular uses of the contents of this project and has provided them 'as-is', and does not claim liabilities incurred by those that may use the contents of this project.

> DISCLAIMER: Currently, this project just auto-provisions an OCI VM, you still need to ssh into it and install outline onto it.

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

This project requires a `terraform.tfvars` file in its root directory to function.

You may use the `example-terraform.tfvars` file provided as a template and fill in the required details, before renaming it to `terraform.tfvars`.

The contents to fill in the oracle cloud platform part of this file:

```Terraform
tenancy_ocid                  = "ocid1.tenancy.oc1..exampleuniqueID"
user_ocid                     = "ocid1.user.oc1..exampleuniqueID"
oracle_api_key_fingerprint    = "ex:am:ple:__:fi:ng:er:pr:int"
oracle_api_private_key_path   = "/path/to/your/private_key.pem"
//oracle_api_private_key_password = "yourPrivateKeyPassword"  # Do not put this if you have not set one
region                        = "ex-example-1"

vcn_cidr_block          = "10.0.0.0/16"
compartment_ocid        = "ocid1.compartment.oc1..exampleuniqueID"
```

are acquired through following the instructions on Oracle Cloud's Documentation to Generate an API Signing Key: https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm and then copying the relevant fields from the 'Configuration file preview' provided on the OCI User Profile > Resources > API keys page https://cloud.oracle.com/identity/domains/my-profile/api-keys to your `terraform.tfvars` file.

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

You must also fill in your ssh details:

```Terraform
ssh_public_key       = "ssh-rsa SSHPublicKey"
//ssh_private_key_path = "~/.ssh/id_rsa" might be different for you
```

After filling out all required details, you can deploy the project

Make sure that the `availability_domain_number` is correct for you. For me, 3 is what works, rather than 1 or 2. This is likely due to my using the free tier.

## Deployment

```bash
$ terraform plan
$ terraform apply
```

## TODO

- [ ] Add the following commands to `main.tf` to fix firewall issues
```bash
$ sudo apt install firewalld
$ sudo systemctl start firewalld && sudo systemctl enable firewalld
$ sudo systemctl status firewalld
$ sudo firewall-cmd --list-ports
$ sudo firewall-cmd --zone=public  --add-port=1024-65535/tcp --permanent
$ sudo firewall-cmd --reload
$ sudo firewall-cmd --list-ports --zone=public
```

- [ ] Add an interactive shell script to configure the VPS more efficiently

- [ ] Add Pi-Hole DNS Configuration for improved privacy

## Credit
Credit to https://github.com/IAmStoxe/oracle-free-tier-wirehole for their main.tf file upon which this project is based
