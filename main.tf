data "vsphere_datacenter" "dc" {
  name = "${var.vsphere_datacenter}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.vsphere_datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  for_each      = var.vsphere_virtual_machines_list
  name          = each.value["pool"]
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  for_each      = var.vsphere_network
  name          = each.value
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  for_each      = var.vsphere_virtual_machines_list
  name          = each.value["template"]
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "cloned_vm" {
  for_each	   = var.vsphere_virtual_machines_list
  name             = each.value["name"]
  resource_pool_id = data.vsphere_resource_pool.pool[each.key].id
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  guest_id = data.vsphere_virtual_machine.template[each.key].guest_id
  scsi_type = data.vsphere_virtual_machine.template[each.key].scsi_type

  dynamic "network_interface" {
  for_each = {for idx, name in each.value.network: idx=>name}
    content {
      network_id = data.vsphere_network.network[network_interface.value].id
    }
  }

  dynamic  "disk" {      
  for_each = {for idx, size in each.value.disks: idx=>size}
    content {
      label            = "disk${disk.key+1}"
      unit_number      = disk.key
      size             = disk.value
    }  
  }

  num_cpus = each.value["cpu"]
  memory   = each.value.ram
  
  wait_for_guest_net_timeout = 0

  clone {
     template_uuid = data.vsphere_virtual_machine.template[each.key].id
  }
}
