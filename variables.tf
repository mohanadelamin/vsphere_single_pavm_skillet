# vCenter connection

variable "user" {
  description = "vSphere user name"
}

variable "password" {
  description = "vSphere password"
}

variable "vsphere_server" {
  description = "vCenter server FQDN or IP"
}

variable "vsphere_unverified_ssl" {
  description = "Is the vCenter using a self signed certificate (true/false)"
}

# VM specifications

variable "vsphere_datacenter" {
  description = "In which datacenter the VM will be deployed"
}

variable "vsphere_vm_name" {
  description = "What is the name of the VM"
}

variable "vsphere_vm_template" {
  description = "Where is the VM template located"
}

variable "vsphere_vm_folder" {
  description = "In which folder the VM will be store"
}

variable "vsphere_cluster" {
  description = "In which cluster the VM will be deployed"
}

variable "vsphere_vcpu_number" {
  description = "How many vCPU will be assigned to the VM (default: 2)"
  default     = "2"
}

variable "vsphere_memory_size" {
  description = "How much RAM will be assigned to the VM (default: 1024)"
  default     = "4608"
}

variable "vsphere_datastore" {
  description = "What is the name of the VM datastore"
}

variable "vsphere_port_group_mgmt" {
  description = "In which port group the VM NIC will be configured for management interface (default: VM Network)"
  default     = "VM Network"
}

variable "vsphere_port_group_untrust" {
  description = "In which port group the VM NIC will be configured for untrust interface (default: VM Network)"
  default     = "VM Network"
}

variable "vsphere_port_group_trust" {
  description = "In which port group the VM NIC will be configured for trust interface (default: VM Network)"
  default     = "VM Network"
}
