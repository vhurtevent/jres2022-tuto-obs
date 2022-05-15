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

data "openstack_images_image_v2" "image_hoster" {
  name        = var.image_name
  most_recent = true
}

data "openstack_networking_network_v2" "net_hoster" {
  name        = "net_hoster"
}

data "openstack_networking_subnet_v2" "subnet_hoster" {
  name        = "subnet_hoster"
}

resource "openstack_networking_port_v2" "port_vm-hoster" {
  name           = "port_vm_idp"
  network_id     = data.openstack_networking_network_v2.net_hoster.id
  fixed_ip {
    subnet_id = data.openstack_networking_subnet_v2.subnet_hoster.id
  }
  admin_state_up = "true"
}

data "local_file" "cloud-init" {
  filename = "cloud-init"
}

resource "openstack_compute_instance_v2" "vm_hoster" {
  name        = "vm_hoster"
  flavor_name = "m2.small"
  key_pair    = var.keypair_name
  user_data   = data.local_file.cloud-init.content

  block_device {
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = "10"
    uuid                  = data.openstack_images_image_v2.image_hoster.id
    boot_index            = 0
    delete_on_termination = true
  }

  network {
    port = openstack_networking_port_v2.port_vm-hoster.id
  }
}

resource "openstack_networking_secgroup_v2" "sg_vm-hoster" {
  name = "sg_vm-hoster"
}

resource "openstack_networking_secgroup_rule_v2" "rule_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.sg_vm-hoster.id
}

resource "openstack_networking_secgroup_rule_v2" "rule_alltcp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1
  port_range_max    = 65535
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.sg_vm-hoster.id
}

resource "openstack_networking_secgroup_rule_v2" "rule_alludp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 1
  port_range_max    = 65535
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.sg_vm-hoster.id
}

resource "openstack_networking_port_secgroup_associate_v2" "port_1" {
  port_id = openstack_networking_port_v2.port_vm-hoster.id
  security_group_ids = [
    openstack_networking_secgroup_v2.sg_vm-hoster.id,
  ]
}
