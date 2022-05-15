
resource "rke_cluster" "kube_coreos" {

  kubernetes_version = "v1.21.7-rancher1-1"

  cluster_name  = "kube-hoster-mutu"

  nodes {
    address = openstack_compute_instance_v2.vm_kube_master_1.access_ip_v4
    user    = "core"
    role    = ["controlplane", "worker", "etcd"]
    ssh_key = file("/root/.ssh/id_ecdsa")
  }

  // nodes {
  //   address = openstack_compute_instance_v2.vm_kube_worker_1.access_ip_v4
  //   user    = "core"
  //   role    = ["worker"]
  //   ssh_key = file("/root/.ssh/id_ecdsa")
  // }

  // nodes {
  //   address = openstack_compute_instance_v2.vm_kube_worker_2.access_ip_v4
  //   user    = "core"
  //   role    = ["worker"]
  //   ssh_key = file("/root/.ssh/id_ecdsa")
  // }

  ingress {
    provider = "none"
  }

  network {
    plugin = "canal"
    options = {
      canal_flex_volume_plugin_dir = "/opt/kubernetes/kubelet-plugins/volume/exec/nodeagent~uds"
      flannel_backend_type = "vxlan"
    }
  }

  services {
    kube_controller {
      extra_args = {
        flex-volume-plugin-dir = "/opt/kubernetes/kubelet-plugins/volume/exec/"
      }
    }
  }

}