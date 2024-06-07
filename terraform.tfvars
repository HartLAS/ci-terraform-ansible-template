## Здесь описываются переменные для создания машин
# cpu - кол-во ядер
# ram - размер в МБ
# disks - размер каждого диска в ГБ
vsphere_datastore = ""
vsphere_datacenter = ""

vsphere_virtual_machine_templates = {
  debian_10 = "debian_10_temp" #В значении имя клонируемой ВМ - берется именно оно
}
vsphere_network = {
  VLAN1             = "VLAN1" #В значении имя VLAN - берется именно оно
}

vsphere_virtual_machines_list = {
    "example_vm-master-1" = {
      name      = "example_vm-master-1"
      desc      = "Описание для инженеров. Его видно только здесь"
      cpu       = 5
      ram       = 5120
      disks     = [50] #Из массива берется кол-во дисков и объем каждого
      template  = "debian_10_temp" #vsphere_virtual_machine_templates один из темплейтов
      pool      = "vsphere_pool"
      network   = ["VLAN1"]
      datastore = "connected to vsphere storage" #не путать с vsphere_datastore
      os = "linux"
    },
    "example_vm-worker-1" = {
      name      = "example_vm-worker-1"
      desc      = "Описание для инженеров. Его видно только здесь"
      cpu       = 8
      ram       = 8192
      disks     = [150] #Из массива берется кол-во дисков и объем каждого
      template  = "debian_10_temp" #vsphere_virtual_machine_templates один из темплейтов
      pool      = "vsphere_pool"
      network   = ["VLAN1"]
      datastore = "connected to vsphere storage" #не путать с vsphere_datastore
      os = "linux"
    },
    "example_vm-nfs" = {
      name      = "example_vm-nfs"
      desc      = "Описание для инженеров. Его видно только здесь"
      cpu       = 3
      ram       = 3072
      disks     = [1024] #Из массива берется кол-во дисков и объем каждого
      template  = "debian_10_temp"
      pool      = "K8S-STORAGE"
      network   = ["VLAN1"] #vsphere_virtual_machine_templates один из темплейтов
      datastore = "connected to vsphere storage" #не путать с vsphere_datastore
      os = "linux"
    }
}

