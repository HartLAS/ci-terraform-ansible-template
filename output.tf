output "vm_ip" {
  value = { for k, v in  vsphere_virtual_machine.cloned_vm : k => v.guest_ip_addresses }
}

output "vm_mac" {
  value = { for k, v in  vsphere_virtual_machine.cloned_vm : k => v.network_interface[*].mac_address}
}
