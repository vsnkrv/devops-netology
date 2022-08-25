resource "yandex_compute_instance" "www" {

  name        = "www"
  platform_id = "standard-v1"
  hostname = "www.vsnk.shop"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8cqj9qiedndmmi3vq6"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet1.id}"
    nat       = true
  }

  metadata = {
    user-data = "${file("meta.txt")}"
  }
}
