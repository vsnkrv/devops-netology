terraform {

  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = ""
  cloud_id  = "b1geph3c0f6qus8lej91"
  folder_id = "b1gg0jj52l7adehme4ff"
  zone      = "ru-central1-a"
}
