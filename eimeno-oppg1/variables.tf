variable "location" {
  type        = string
  description = "The Azure region that the resources should be deployed in"

}

variable "base_name" {
  type        = string
  description = "The base name for the storage account resource"
}

variable "sa_ak_secret_name" {
  type        = string
  description = "The name of the secret for access key of the storage account"
}

variable "vm_username_secret_name" {
  type        = string
  description = "The name of the secret for the username of the virtual machine"
}

variable "vm_username" {
  type        = string
  description = "The username for the virtual machine"
}

variable "vm_passwd_secret_name" {
  type        = string
  description = "The name of the secret for the password of the virtual machine"
}

variable "vm_passwd" {
  type        = string
  description = "The password for the virtual machine"
}



