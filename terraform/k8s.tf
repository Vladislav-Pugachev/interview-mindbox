resource "local_file" "inventory-k8s" {
  content     = templatefile("./inventory.tpl",
  {
    control_node_private_ip = yandex_compute_instance.control_node.network_interface.0.ip_address
    nat_ext_ip = yandex_compute_instance.nat.network_interface.0.nat_ip_address
    control_node_hostname = yandex_compute_instance.control_node.hostname
    worker_nodes = yandex_compute_instance.worker_nodes
})
  filename = "./inventory.yml"
}

resource "null_resource" "predeploy-k8s" {
  depends_on = [local_file.inventory-k8s]
  provisioner "local-exec" {
    command = "ansible-playbook -i ${yandex_compute_instance.control_node.network_interface.0.ip_address}, ./playbook_k8s.yml --key-file ./ssh/id_rsa --ssh-extra-args='-o StrictHostKeyChecking=no  -o UserKnownHostsFile=/dev/null  -o ProxyCommand=\"ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -W %h:%p ${var.ui}@${yandex_compute_instance.nat.network_interface.0.nat_ip_address} -i ./ssh/id_rsa\"'"
  }
}


resource "null_resource" "deploy-k8s" {
  depends_on = [null_resource.predeploy-k8s]
    provisioner "remote-exec" {
      connection {
        bastion_host = yandex_compute_instance.nat.network_interface.0.nat_ip_address
        bastion_user = var.ui
        bastion_private_key = "${file("./ssh/id_rsa")}"
        host = yandex_compute_instance.control_node.network_interface.0.ip_address
        type = "ssh"
        user = var.ui
        private_key = "${file("./ssh/id_rsa")}"
      }
      inline = ["ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ./kubespray/inventory/sample/hosts.yml ./kubespray/cluster.yml -b -v -e 'cluster_access_ip=${yandex_compute_instance.nat.network_interface.0.nat_ip_address}:6443'"]
      }
}

resource "null_resource" "copy_config_k8s" {
  depends_on = [null_resource.deploy-k8s]
  provisioner "local-exec" {
    command = "ssh -i ./ssh/id_rsa ${var.ui}@${yandex_compute_instance.control_node.network_interface.0.ip_address} -o StrictHostKeyChecking=no -o ProxyCommand=\"ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -W %h:%p ${var.ui}@${yandex_compute_instance.nat.network_interface.0.nat_ip_address} -i ./ssh/id_rsa\" \"sudo cat /etc/kubernetes/admin.conf\" >./k8s.conf"
  }
}
