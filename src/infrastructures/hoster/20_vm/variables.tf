variable "image_name" {
  type        = string
  description = "Nom de l'image"
  default     = "debian-11-generic-amd64-20210814-734"
}

variable "keypair_name" {
  type        = string
  description = "Nom de la keypair"
  default     = "keypair_hoster"
}
