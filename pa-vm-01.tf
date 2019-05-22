#===============================================================================
# vSphere Provider
#===============================================================================
provider "vsphere" {
  version        = "1.5.0"
  vsphere_server = "${var.vsphere_vcenter}"
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"

  allow_unverified_ssl = "true"
}

#===============================================================================
# vSphere Data
#===============================================================================

data "vsphere_datacenter" "dc" {
  name = "${var.vsphere_datacenter}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "${var.vsphere_cluster}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.vsphere_datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "mgmt_network" {
  name          = "${var.vsphere_port_group_mgmt}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "untrust_network" {
  name          = "${var.vsphere_port_group_untrust}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "trust_network" {
  name          = "${var.vsphere_port_group_trust}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}


data "vsphere_virtual_machine" "template" {
  name          = "${var.vsphere_vm_template}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

#===============================================================================
# vSphere Resources
#===============================================================================

# Create a vSphere VM folder #
resource "vsphere_folder" "terraform-pa-vm" {
  path          = "${var.vsphere_vm_folder}"
  type          = "vm"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

# Create a vSphere VM in the folder #
resource "vsphere_virtual_machine" "terraform-pa-vm" {
  # VM placement #
  name             = "${var.vsphere_vm_name}"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  folder           = "${vsphere_folder.terraform-pa-vm.path}"

  # VM resources #
  num_cpus = "${var.vsphere_vcpu_number}"
  memory   = "${var.vsphere_memory_size}"

  # Guest OS #
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

  # VM storage #
  disk {
    label            = "${var.vsphere_vm_name}.vmdk"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
  }

  # VM networking - Management interface#
  network_interface {
    network_id   = "${data.vsphere_network.mgmt_network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  # VM networking - untrsut interface#
  network_interface {
    network_id   = "${data.vsphere_network.untrust_network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  # VM networking - trust interface#
  network_interface {
    network_id   = "${data.vsphere_network.trust_network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  # Customization of the VM #
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
  }

  # Advanced options #
  wait_for_guest_net_timeout = false
  wait_for_guest_net_routable = false
}
