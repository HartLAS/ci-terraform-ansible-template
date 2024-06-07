# vsphere server, defaults to localhost
variable "vsphere_server" {
  default = ""
}

# vsphere datacenter the virtual machine will be deployed to. empty by default.
variable "vsphere_datacenter" {
  default = ""
}

# vsphere resource pool the virtual machine will be deployed to. empty by default.
variable "vsphere_resource_pool" {
  default = ""
}

# vsphere datastore the virtual machine will be deployed to. empty by default.
variable "vsphere_datastore" {
  default = ""
}

# vsphere network the virtual machine will be connected to. empty by default.
variable "vsphere_network" {
  default = ""
}

# vsphere virtual machine template that the virtual machine will be cloned from. empty by default.
variable "vsphere_virtual_machine_template" {
  default = ""
}

# the name of the vsphere virtual machine that is created. empty by default.
variable "vsphere_virtual_machines_list" {
  default = ""
}

variable "vsphere_virtual_machine_templates" {
 default = ""
}
