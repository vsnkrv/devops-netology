# Домашнее задание к занятию "7.3. Основы и принцип работы Терраформ"

## Задача 1. Создадим бэкэнд в S3 (необязательно, но крайне желательно).

Если в рамках предыдущего задания у вас уже есть аккаунт AWS, то давайте продолжим знакомство со взаимодействием
терраформа и aws. 

1. Создайте s3 бакет, iam роль и пользователя от которого будет работать терраформ. Можно создать отдельного пользователя,
а можно использовать созданного в рамках предыдущего задания, просто добавьте ему необходимы права, как описано 
[здесь](https://www.terraform.io/docs/backends/types/s3.html).
1. Зарегистрируйте бэкэнд в терраформ проекте как описано по ссылке выше. 

```
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
```

## Задача 2. Инициализируем проект и создаем воркспейсы. 

1. Выполните `terraform init`:
    * если был создан бэкэнд в S3, то терраформ создат файл стейтов в S3 и запись в таблице 
dynamodb.
    * иначе будет создан локальный файл со стейтами.  
1. Создайте два воркспейса `stage` и `prod`.
1. В уже созданный `aws_instance` добавьте зависимость типа инстанса от вокспейса, что бы в разных ворскспейсах 
использовались разные `instance_type`.
1. Добавим `count`. Для `stage` должен создаться один экземпляр `ec2`, а для `prod` два. 
1. Создайте рядом еще один `aws_instance`, но теперь определите их количество при помощи `for_each`, а не `count`.
1. Что бы при изменении типа инстанса не возникло ситуации, когда не будет ни одного инстанса добавьте параметр
жизненного цикла `create_before_destroy = true` в один из рессурсов `aws_instance`.
1. При желании поэкспериментируйте с другими параметрами и рессурсами.

В виде результата работы пришлите:
* Вывод команды `terraform workspace list`.
* Вывод команды `terraform plan` для воркспейса `prod`.  


Сделал бакенд локально, так как хранилище S3 создавалось, объекты туда записывались, но не выводились командой terraform workspace list
не стал тратить время на разбирательство, почему так происходило.

```
user@acer-r:~/devops-netology/07-terraform-03-basic$ terraform workspace list
  default
* prod
  stage

user@acer-r:~/devops-netology/07-terraform-03-basic$ terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.vm[0] will be created
  + resource "yandex_compute_instance" "vm" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCqlvPI+bQzJYBqWP8IT6mHGzybhKtP2tBQPycHHVgoLf9AMBEp4JPQnWFM5IVcuv5bHiKxf7AKnTXTjylZRIySbds8YF4eofr3M3+8ZKwI7NmBRRZLYvWWYj6zh1PlqJ3CN/PGzTzfgDp4E5P/mXYynJlXivF8oHXPWS1kETdRuy2IWUA5crSIsNP8lPH4GDB3s68qd4jyL3HYQT5jhkcj1yykRKLJhPUXJqKPNGCis2XEgxtzh+fPGyN1SQMbSbfu3/0+3WA884gSos8DifHJnxJdgJib4Itt6+Y0Gb0YL0PGduuMqNfOFyY0zPcWOsZ0YPZI6R1o81V3XpoU3q0HGSBNxDV9bBJnLJSQKMdt9Xf/89gYv4UZABU//n+dmcS2jHcXbjtFSyLpynbu+cbxih6Z+OjTGPUDG5OSRo7GAVdtHQETbVC55zBUwDAY8AgPBax847A2Jba/xSiMnck9JZTKZGDkaD7zWGEfLhFrqxQ2IcXU5GSD6Q7JlImnCYM= user@acer-r
            EOT
        }
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8mfc6omiki5govl68h"
              + name        = (known after apply)
              + size        = 20
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 8
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm[1] will be created
  + resource "yandex_compute_instance" "vm" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCqlvPI+bQzJYBqWP8IT6mHGzybhKtP2tBQPycHHVgoLf9AMBEp4JPQnWFM5IVcuv5bHiKxf7AKnTXTjylZRIySbds8YF4eofr3M3+8ZKwI7NmBRRZLYvWWYj6zh1PlqJ3CN/PGzTzfgDp4E5P/mXYynJlXivF8oHXPWS1kETdRuy2IWUA5crSIsNP8lPH4GDB3s68qd4jyL3HYQT5jhkcj1yykRKLJhPUXJqKPNGCis2XEgxtzh+fPGyN1SQMbSbfu3/0+3WA884gSos8DifHJnxJdgJib4Itt6+Y0Gb0YL0PGduuMqNfOFyY0zPcWOsZ0YPZI6R1o81V3XpoU3q0HGSBNxDV9bBJnLJSQKMdt9Xf/89gYv4UZABU//n+dmcS2jHcXbjtFSyLpynbu+cbxih6Z+OjTGPUDG5OSRo7GAVdtHQETbVC55zBUwDAY8AgPBax847A2Jba/xSiMnck9JZTKZGDkaD7zWGEfLhFrqxQ2IcXU5GSD6Q7JlImnCYM= user@acer-r
            EOT
        }
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8mfc6omiki5govl68h"
              + name        = (known after apply)
              + size        = 20
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 8
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm-2["m1"] will be created
  + resource "yandex_compute_instance" "vm-2" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCqlvPI+bQzJYBqWP8IT6mHGzybhKtP2tBQPycHHVgoLf9AMBEp4JPQnWFM5IVcuv5bHiKxf7AKnTXTjylZRIySbds8YF4eofr3M3+8ZKwI7NmBRRZLYvWWYj6zh1PlqJ3CN/PGzTzfgDp4E5P/mXYynJlXivF8oHXPWS1kETdRuy2IWUA5crSIsNP8lPH4GDB3s68qd4jyL3HYQT5jhkcj1yykRKLJhPUXJqKPNGCis2XEgxtzh+fPGyN1SQMbSbfu3/0+3WA884gSos8DifHJnxJdgJib4Itt6+Y0Gb0YL0PGduuMqNfOFyY0zPcWOsZ0YPZI6R1o81V3XpoU3q0HGSBNxDV9bBJnLJSQKMdt9Xf/89gYv4UZABU//n+dmcS2jHcXbjtFSyLpynbu+cbxih6Z+OjTGPUDG5OSRo7GAVdtHQETbVC55zBUwDAY8AgPBax847A2Jba/xSiMnck9JZTKZGDkaD7zWGEfLhFrqxQ2IcXU5GSD6Q7JlImnCYM= user@acer-r
            EOT
        }
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8mfc6omiki5govl68h"
              + name        = (known after apply)
              + size        = 10
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_vpc_network.network-1 will be created
  + resource "yandex_vpc_network" "network-1" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "network1"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.subnet-1 will be created
  + resource "yandex_vpc_subnet" "subnet-1" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet1"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.10.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 5 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + external_ip_address_vm = [
      + (known after apply),
      + (known after apply),
    ]
  + internal_ip_address_vm = [
      + (known after apply),
      + (known after apply),
    ]

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
user@acer-r:~/devops-netology/07-terraform-03-basic$
```

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
