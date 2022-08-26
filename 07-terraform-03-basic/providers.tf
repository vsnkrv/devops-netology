terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }

# backend "s3" {
#    endpoint   = "storage.yandexcloud.net"
#    bucket     = "vsnkrv-bucket"
#    region     = "ru-central1-a"
#    key        = "./state.tfstate"
#    access_key = "YCAJE0ko0TWkX6ANQNy06UfZ4"
#    secret_key = "YCOIgcQVEYRj2PnMykBIGXpJ1VCtGrM55YWSDLxY"

#    skip_region_validation      = true
#    skip_credentials_validation = true
# }
}
provider "yandex" {
  token                    = "y0_AQAAAAATUmf3AATuwQAAAADLks_IWo53R-m8S0ymSCssZdfkuVpZU_E"
  cloud_id                 = "b1geph3c0f6qus8lej91"
  folder_id                = "b1gg0jj52l7adehme4ff"
  zone                     = "ru-central1-a"
}
