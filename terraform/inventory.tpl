all:
  hosts:
    ${control_node_hostname}:
      ansible_host: ${control_node_private_ip}
      ip: ${control_node_private_ip}
%{for node in worker_nodes~}
    ${node.hostname}:
      ansible_host: ${node.network_interface.0.ip_address}
      ip: ${node.network_interface.0.ip_address}
%{ endfor ~}
  children:
    kube_control_plane:
      hosts:
        ${control_node_hostname}:
    kube_node:
      hosts:
%{for node in worker_nodes~}
        ${node.hostname}:
%{ endfor ~}
    etcd:
      hosts:
        ${control_node_hostname}:
    k8s_cluster:
      children:
        kube_control_plane:
        kube_node:
      vars:
        supplementary_addresses_in_ssl_keys: ['${nat_ext_ip}']
    calico_rr:
      hosts: {}
