## Required providers
terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
    ct = {
      source  = "poseidon/ct"
      version = "0.9.1"
    }
    rke = {
      source  = "rancher/rke"
      version = "~> 1.3.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.7.1"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.4.1"
    }
  }
}

provider "kubernetes" {
  host     = rke_cluster.kube_coreos.api_server_url
  username = rke_cluster.kube_coreos.kube_admin_user

  client_certificate     = rke_cluster.kube_coreos.client_cert
  client_key             = rke_cluster.kube_coreos.client_key
  cluster_ca_certificate = rke_cluster.kube_coreos.ca_crt
}

provider "helm" {
  kubernetes {
    host     = rke_cluster.kube_coreos.api_server_url
    username = rke_cluster.kube_coreos.kube_admin_user

    client_certificate     = rke_cluster.kube_coreos.client_cert
    client_key             = rke_cluster.kube_coreos.client_key
    cluster_ca_certificate = rke_cluster.kube_coreos.ca_crt
  }
}
