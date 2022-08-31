resource "yandex_compute_instance" "monitoring" {
  name     = "monitoring"
  platform_id = "standard-v1"
  hostname = "monitoring.vsnk.shop"

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8fte6bebi857ortlja"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("meta.txt")}"
  }
}
