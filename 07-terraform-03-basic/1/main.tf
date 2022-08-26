terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token                    = "y0_AQAAAAATUmf3AATuwQAAAADLks_IWo53R-m8S0ymSCssZdfkuVpZU_E"
  cloud_id                 = "b1geph3c0f6qus8lej91"
  folder_id                = "b1gg0jj52l7adehme4ff"
  zone                     = "ru-central1-a"
}

resource "yandex_iam_service_account" "sa" {
  name      = "service-acc"
}

// Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
  folder_id = "b1gg0jj52l7adehme4ff"
}

// Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

// Создание бакета с использованием ключа
resource "yandex_storage_bucket" "test" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = "vsnkrv-bucket"
}

output "access_key" {
  value = yandex_iam_service_account_static_access_key.sa-static-key.access_key
}

output "secret_key" {
  value = nonsensitive(yandex_iam_service_account_static_access_key.sa-static-key.secret_key)
}
