output "external_ip_control_node" {
    value = yandex_compute_instance.nat.network_interface.0.nat_ip_address
}