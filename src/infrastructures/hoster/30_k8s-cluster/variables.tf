variable "image_name" {
  type        = string
  description = "Nom de l'image"
  default     = "fedora-coreos-35.20220410.3.1-openstack.x86_64"
}

variable "ssh_pub_key" {
  type        = string
  description = "Contenu de la clef publique"
}

variable "os_auth_url" {
  type        = string
  description = "Endpoint d'auth OpenStack"
  default     = "https://iaas.unistra.fr:13000/v3"
}

variable "os_application_credential_id" {
  type        = string
  description = "Application Credential ID"
}

variable "os_application_credential_secret" {
  type        = string
  description = "Application Credential Secret"
}
