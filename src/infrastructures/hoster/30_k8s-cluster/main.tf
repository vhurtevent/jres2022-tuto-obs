
resource "template_file" "tpl_butane_coreos" {
  template = "${file("${path.module}/butane/coreos.bu.tpl")}"
  vars = {
    ssh_pub_key = "${var.ssh_pub_key}"
  }
}

data "ct_config" "coreos" {
  content      = "${template_file.tpl_butane_coreos.rendered}"
  strict       = true
  pretty_print = false
}

data "openstack_images_image_v2" "image_coreos" {
  name        = var.image_name
  most_recent = true
}

data "openstack_networking_network_v2" "net_hoster" {
  name = "net_hoster"
}

data "openstack_networking_subnet_v2" "subnet_hoster" {
  name = "subnet_hoster"
}

resource "openstack_networking_port_v2" "port_kube_master_1" {
  name           = "port_kube_master_1"
  network_id     = data.openstack_networking_network_v2.net_hoster.id
  fixed_ip {
    subnet_id = data.openstack_networking_subnet_v2.subnet_hoster.id
  }
  admin_state_up = "true"
}

resource "openstack_networking_secgroup_v2" "sg_kube_master_1" {
  name = "sg_kube_master_1"
}

resource "openstack_networking_secgroup_rule_v2" "kube_master_alltcp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1
  port_range_max    = 65535
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.sg_kube_master_1.id
}

resource "openstack_networking_secgroup_rule_v2" "kube_master_alludp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 1
  port_range_max    = 65535
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.sg_kube_master_1.id
}

resource "openstack_networking_port_secgroup_associate_v2" "kube_master_1" {
  port_id = openstack_networking_port_v2.port_kube_master_1.id
  security_group_ids = [
    openstack_networking_secgroup_v2.sg_kube_master_1.id,
  ]
}

resource "openstack_compute_instance_v2" "vm_kube_master_1" {
  name        = "vm_kube_hoster_1"
  flavor_name = "m4.medium"

  block_device {
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = "50"
    uuid                  = data.openstack_images_image_v2.image_coreos.id
    boot_index            = 0
    delete_on_termination = true
  }

  network {
    port = openstack_networking_port_v2.port_kube_master_1.id
  }

  user_data = data.ct_config.coreos.rendered
  config_drive = true

}

// resource "openstack_networking_port_v2" "port_kube_worker_1" {
//   name           = "port_kube_worker_1"
//   network_id     = data.openstack_networking_network_v2.net_hoster.id
//   fixed_ip {
//     subnet_id = data.openstack_networking_subnet_v2.subnet_hoster.id
//   }
//   admin_state_up = "true"
// }

// resource "openstack_compute_instance_v2" "vm_kube_worker_1" {
//   name        = "vm_kube_worker_1"
//   flavor_name = "m4.medium"

//   block_device {
//     source_type           = "image"
//     destination_type      = "volume"
//     volume_size           = "50"
//     uuid                  = data.openstack_images_image_v2.image_coreos.id
//     boot_index            = 0
//     delete_on_termination = true
//   }

//   network {
//     port = openstack_networking_port_v2.port_kube_worker_1.id
//   }

//   user_data = data.ct_config.coreos.rendered
//   config_drive = true

// }

// resource "openstack_networking_port_v2" "port_kube_worker_2" {
//   name           = "port_kube_worker_2"
//   network_id     = data.openstack_networking_network_v2.net_hoster.id
//   fixed_ip {
//     subnet_id = data.openstack_networking_subnet_v2.subnet_hoster.id
//   }
//   admin_state_up = "true"
// }

// resource "openstack_compute_instance_v2" "vm_kube_worker_2" {
//   name        = "vm_kube_worker_2"
//   flavor_name = "m4.medium"

//   block_device {
//     source_type           = "image"
//     destination_type      = "volume"
//     volume_size           = "50"
//     uuid                  = data.openstack_images_image_v2.image_coreos.id
//     boot_index            = 0
//     delete_on_termination = true
//   }

//   network {
//     port = openstack_networking_port_v2.port_kube_worker_2.id
//   }

//   user_data = data.ct_config.coreos.rendered
//   config_drive = true

// }

resource "openstack_networking_secgroup_v2" "sg_kube_worker" {
  name = "sg_kube_worker"
}

resource "openstack_networking_secgroup_rule_v2" "kube_worker_alltcp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1
  port_range_max    = 65535
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.sg_kube_worker.id
}

resource "openstack_networking_secgroup_rule_v2" "kube_worker_alludp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 1
  port_range_max    = 65535
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.sg_kube_worker.id
}

// resource "openstack_networking_port_secgroup_associate_v2" "kube_worker_1" {
//   port_id = openstack_networking_port_v2.port_kube_worker_1.id
//   security_group_ids = [
//     openstack_networking_secgroup_v2.sg_kube_worker.id,
//   ]
// }

// resource "openstack_networking_port_secgroup_associate_v2" "kube_worker_2" {
//   port_id = openstack_networking_port_v2.port_kube_worker_2.id
//   security_group_ids = [
//     openstack_networking_secgroup_v2.sg_kube_worker.id,
//   ]
// }
