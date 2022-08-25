terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = ""
  cloud_id  = "b1g1gpqkbs44i6e7j0vh"
  folder_id = "b1g1gpqkbs44i6e7j0vh"
  zone      = "ru-central1-b"
}
