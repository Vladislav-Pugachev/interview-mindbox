variable "folder_id" {
  description =  "Yandex folder_id"
  type = string
}

variable "cloud_id" {
  description =  "Yandex cloud_id"
  type = string
}

variable "token" {
  description =  "Yandex token"
  type = string
}

variable "subnet" {
    description = "подсети"
    type= map
    default = {
        "ru-central1-a" = "10.0.0.0/24"
        "ru-central1-b" = "10.0.1.0/24"
        "ru-central1-c" = "10.0.2.0/24"
}
}

variable "worker_node" {
    description = "node"
    type= map
    default = {
        "worker-node-1" ="ru-central1-a" 
        "worker-node-2" ="ru-central1-b"
        "worker-node-3" ="ru-central1-c" 
        "worker-node-4" ="ru-central1-a"
        "worker-node-5" ="ru-central1-b" 
}
}

variable "ui" {
    type        = string
    description = "current whoami"
}