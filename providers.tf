terraform {
  backend "http" {
    skip_cert_verification = true
  }
  required_providers {
    vsphere = {
      source  = "local/hashicorp/vsphere"
      version = "= 2.5.1"
    }
    time = {
      source = "local/hashicorp/time"
      version = "= 0.9.2"
    }
    vault = {
      source = "local/hashicorp/vault"
      version = "= 3.20.1"
    }
  }
}

provider "vault" {
}

provider "vsphere" {
  user           = "${data.vault_generic_secret.vsphere.data[""]}"
  password       = "${data.vault_generic_secret.vsphere.data[""]}"
  vsphere_server = "${var.vsphere_server}"
  allow_unverified_ssl = true
}
