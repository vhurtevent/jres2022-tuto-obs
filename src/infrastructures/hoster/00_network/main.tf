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

data "openstack_networking_router_v2" "rtr_main" {
  name = "rtr_main"
}

resource "openstack_networking_network_v2" "net_hoster" {
  name           = "net_hoster"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_hoster" {
  name       = "subnet_hoster"
  network_id = openstack_networking_network_v2.net_hoster.id
  cidr       = var.subnet_cidr
  ip_version = 4
}

resource "openstack_networking_router_interface_v2" "rtrint_main_hoster" {
  router_id = data.openstack_networking_router_v2.rtr_main.id
  subnet_id = openstack_networking_subnet_v2.subnet_hoster.id
}
