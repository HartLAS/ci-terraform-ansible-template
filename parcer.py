# -*- coding: utf-8 -*-
import json
import hcl
import sys
from sys import argv
import yaml

script, tfsate_file = argv
inventory_template_file = 'inventory-template.yaml'
inventory_file = 'inventory.yaml'
tfvars_file = 'terraform.tfvars'

##### Открываем шаблон инвентарника Ansible
with open(inventory_template_file, 'r') as file:
	inventory_data = yaml.load(file, Loader=yaml.FullLoader)

##### Открываем tfstate
with open(tfsate_file) as json_file:
    tfstate_contents = json.load(json_file)

##### Открываем tfvars  
with open(tfvars_file) as hcl_file:
      tf_obj = hcl.load(hcl_file)

##### Перебираем тачки из tfvars и добавляем блоки с названием пулов для ямла, куда группируем машины
for item in tf_obj['vsphere_virtual_machines_list']:
        if "children" not in inventory_data[tf_obj['vsphere_virtual_machines_list'][item]["os"]]:
              inventory_data[tf_obj['vsphere_virtual_machines_list'][item]["os"]]["children"] = {}
        inventory_data[tf_obj['vsphere_virtual_machines_list'][item]["os"]]["children"][tf_obj['vsphere_virtual_machines_list'][item]["pool"]] = {}
        inventory_data[tf_obj['vsphere_virtual_machines_list'][item]["os"]]["children"][tf_obj['vsphere_virtual_machines_list'][item]["pool"]]['hosts'] = {}

##### Перебираем тачки из tfstate и создаем ключ-значение для ямла, сохраняя данные в dict
for hosts in tfstate_contents['resources'][6]['instances']:
    vm_info = {}
    host_name = hosts['attributes']['name']
    defualt_ip = hosts['attributes']['default_ip_address']
    esxi = hosts['attributes']['host_system_id']
    pool_id = hosts['attributes']['resource_pool_id']
    with open(tfvars_file) as hcl_file:
           tf_obj = hcl.load(hcl_file)
           vm_pool = tf_obj['vsphere_virtual_machines_list'][host_name]['pool']
           os = tf_obj['vsphere_virtual_machines_list'][host_name]['os']
           vm_datastore = tf_obj['vsphere_virtual_machines_list'][host_name]["datastore"]
           ram = tf_obj['vsphere_virtual_machines_list'][host_name]["ram"]
           cpu_num = tf_obj['vsphere_virtual_machines_list'][host_name]["cpu"]
           disks_arr = []
           interfaces_arr = []
           addresses_arr = []
           for disk in hosts['attributes']["disk"]:
                 disks_arr.append(disk["size"])
           for interface in hosts['attributes']["network_interface"]:
                 interfaces_arr.append(interface['mac_address'])
           for addr in hosts['attributes']["guest_ip_addresses"]:
                 addresses_arr.append(addr)

           inventory_data[os]["children"][vm_pool]['hosts'][host_name] = dict(ansible_ssh_host=defualt_ip, 
                               disks=disks_arr, 
                               interfaces=interfaces_arr, 
                               addresses=addresses_arr, 
                               datastore=vm_datastore,
                               esxi_host_id=esxi,
                               memory=ram,
                               cpus=cpu_num,
                               pool_id=pool_id)

### Открываем инвентраник на запись и сохраняем
with open(inventory_file, 'w') as outfile:
    yaml.dump(inventory_data, outfile, default_flow_style=False, explicit_start=True)
