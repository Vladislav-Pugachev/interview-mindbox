resource "yandex_compute_instance" "nat" {
    name = "nat-node"
    hostname = "nat-node"
    zone = "ru-central1-a"
    platform_id = "standard-v1"
    folder_id = var.folder_id
    resources {
      cores = 2
      memory = 2
    }
    boot_disk {
      initialize_params {
        image_id = "fd8tckeqoshi403tks4l"
        size = 5
        type="network-ssd"
      }
    }
    network_interface {
        nat = true
        subnet_id = yandex_vpc_subnet.subnet-nat.id
        ip_address = "192.168.2.254"
    }
    metadata = {
        user-data = "${file("./users.yml")}"
  }
    provisioner "remote-exec" {
      connection {
        host = yandex_compute_instance.nat.network_interface.0.nat_ip_address
        type = "ssh"
        user = var.ui
        private_key = "${file("./ssh/id_rsa")}"
      }
      inline = ["whoami"]
      }
}

resource "null_resource" "config-nat" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ${yandex_compute_instance.nat.network_interface.0.nat_ip_address}, ./playbook_nat.yml --key-file ./ssh/id_rsa"
  }
}