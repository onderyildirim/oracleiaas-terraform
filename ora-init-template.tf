data "local_file" "ora-vm-script" {
  filename = "${path.module}/ora-vm-script.yml"
}

data "template_file" "ora-vm-script-params" {
  template = file("${path.module}/ora-vm-script-params.template.yml")
  vars     = {
                oraMntDir="${local.oraMntDir}"
                ANFipAddr="${azurerm_netapp_volume.anfVolume.mount_ip_addresses[0]}"
                ANFvolumeName="${azurerm_netapp_volume.anfVolume.name}"
             }
}


# cloud-init config that installs the provisioning scripts
# data "template_file" "ora-vm-cloudinit-template" {
#   template = file("${path.module}/cloud-init-oravm-config.yaml.tpl")
#   vars     = {
#                 oraMntDir="${local.oraMntDir}"
#                 ANFipAddr="${azurerm_netapp_volume.anfVolume.mount_ip_addresses[0]}"
#                 ANFvolumeName="${azurerm_netapp_volume.anfVolume.name}"
#              }
# }

data "cloudinit_config" "ora-vm-cloudinit-config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.ora-vm-script-params.rendered
  }

  part {
    content_type = "text/cloud-config"
    content      = data.local_file.ora-vm-script.content
  }
}

output "out-ora-vm-script" {
  value = data.local_file.ora-vm-script.content
}
output "out-ora-vm-script-params" {
  value = data.template_file.ora-vm-script-params.rendered
}
output "out-custom-data" {
  value = data.cloudinit_config.ora-vm-cloudinit-config.rendered
}
