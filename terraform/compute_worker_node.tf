resource "yandex_compute_instance" "worker_nodes" {
    depends_on = [yandex_compute_instance.control_node]
    for_each = var.worker_node
    name = each.key
    hostname = each.key
    zone = each.value
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
        subnet_id = yandex_vpc_subnet.subnet[each.value].id
    }
    metadata = {
        user-data = "${file("./users.yml")}"
  }

}