output kubeconfig {
  value = rke_cluster.kube_coreos.kube_config_yaml
  sensitive = true
}
