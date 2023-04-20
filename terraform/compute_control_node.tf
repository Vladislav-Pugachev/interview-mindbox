resource "yandex_compute_instance" "control_node" {
    name = "control-node"
    hostname = "control-node"
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
        size = 10
      }
    }
    network_interface {
        nat = false
        subnet_id = yandex_vpc_subnet.subnet["ru-central1-a"].id
        ip_address = cidrhost(yandex_vpc_subnet.subnet["ru-central1-a"].v4_cidr_blocks[0],254)
    }
    metadata = {
        user-data = "${file("./users.yml")}"
  }
}