resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_dns_zone" "zone1" {
  name        = "vsnk-shop"
  description = "vsnk.shop public zone"

  labels = {
    label1 = "vsnk-shop"
  }

  zone    = "vsnk.shop."
  public  = true
}

resource "yandex_dns_recordset" "vsnk" {
  zone_id = yandex_dns_zone.zone1.id
  name    = "vsnk.shop."
  type    = "A"
  ttl     = 200
  data    = [yandex_compute_instance.vsnk.network_interface.0.nat_ip_address]
}

resource "yandex_dns_recordset" "app" {
  zone_id = yandex_dns_zone.zone1.id
  name    = "www.vsnk.shop."
  type    = "A"
  ttl     = 200
  data    = [yandex_compute_instance.vsnk.network_interface.0.nat_ip_address]
}

resource "yandex_dns_recordset" "gitlab" {
  zone_id = yandex_dns_zone.zone1.id
  name    = "gitlab.vsnk.shop."
  type    = "A"
  ttl     = 200
  data    = [yandex_compute_instance.vsnk.network_interface.0.nat_ip_address]
}

resource "yandex_dns_recordset" "grafana" {
  zone_id = yandex_dns_zone.zone1.id
  name    = "grafana.vsnk.shop."
  type    = "A"
  ttl     = 200
  data    = [yandex_compute_instance.vsnk.network_interface.0.nat_ip_address]
}

resource "yandex_dns_recordset" "prometheus" {
  zone_id = yandex_dns_zone.zone1.id
  name    = "prometheus.vsnk.shop."
  type    = "A"
  ttl     = 200
  data    = [yandex_compute_instance.vsnk.network_interface.0.nat_ip_address]
}

resource "yandex_dns_recordset" "alertmanager" {
  zone_id = yandex_dns_zone.zone1.id
  name    = "alertmanager.vsnk.shop."
  type    = "A"
  ttl     = 200
  data    = [yandex_compute_instance.vsnk.network_interface.0.nat_ip_address]
}
