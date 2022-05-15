# Define required providers
terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}

# Configure the OpenStack Provider
provider "openstack" {
}

resource "openstack_compute_keypair_v2" "keypair_hoster" {
  name       = "keypair_hoster"
  public_key = var.ssh_pub_key
}