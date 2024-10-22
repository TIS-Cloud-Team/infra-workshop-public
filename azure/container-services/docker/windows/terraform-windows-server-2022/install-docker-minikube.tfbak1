## copy file
## https://stackoverflow.com/questions/48567881/how-can-i-use-terraforms-file-provisioner-to-copy-from-my-local-machine-onto-a
## https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec

## step 1 copy install_docker_minikube.sh from local to remote
resource "null_resource" "install_docker_minikube_copy_script" {
  provisioner "file" {
    source      = "install_minikube.sh"
    destination = "/tmp/install_minikube.sh"
  }

  connection {
    type        = "ssh"
    user        = "adminuser"
    private_key = file("${path.module}/id_rsa_${local.app_name}")
    host        = azurerm_linux_virtual_machine.vm.public_ip_address
  }

  depends_on = [azurerm_linux_virtual_machine.vm]
}

## step 2 - run install script on remote linux vm
resource "null_resource" "install_docker_minikube_execute" {
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_minikube.sh",
      "/tmp/install_minikube.sh"
    ]

    connection {
      type        = "ssh"
      user        = "adminuser"
      private_key = file("${path.module}/id_rsa_${local.app_name}")
      host        = azurerm_linux_virtual_machine.vm.public_ip_address
    }
  }

  depends_on = [null_resource.install_docker_minikube_copy_script]
}

## step 3 - copy log file from remote linux vm to local
resource "null_resource" "install_docker_minikube_copy_log" {
  provisioner "local-exec" {
    command = <<EOT
      chmod 600 ${path.module}/id_rsa_${local.app_name}
      scp -o StrictHostKeyChecking=no -i ${path.module}/id_rsa_${local.app_name} adminuser@${azurerm_linux_virtual_machine.vm.public_ip_address}:/tmp/install_minikube.log ${path.module}/install_minikube.log
    EOT
  }

  depends_on = [null_resource.install_docker_minikube_execute]
}