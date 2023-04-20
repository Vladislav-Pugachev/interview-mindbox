resource "yandex_vpc_network" "network" {
  name = "network"
  folder_id = var.folder_id
}

resource "yandex_vpc_route_table" "default" {
  network_id = yandex_vpc_network.network.id
  folder_id = var.folder_id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address = "192.168.2.254"
  }
}

resource "yandex_vpc_subnet" "subnet" {
  depends_on = [yandex_vpc_network.network]
  for_each = var.subnet
  v4_cidr_blocks = [each.value]
  zone = each.key
  network_id = yandex_vpc_network.network.id
  folder_id = var.folder_id
  route_table_id = yandex_vpc_route_table.default.id
}

resource "yandex_vpc_subnet" "subnet-nat" {
  v4_cidr_blocks = ["192.168.2.0/24"]
  zone = "ru-central1-a"
  network_id = yandex_vpc_network.network.id
  folder_id = var.folder_id
}