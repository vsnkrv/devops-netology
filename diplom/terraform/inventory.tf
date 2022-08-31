resource "local_file" "inventory" {
  content = <<-DOC
    # Ansible inventory containing variable values from Terraform.
    # Generated by Terraform.

---
all:
  children:
    nginx:
      hosts:
        nginx:
          ansible_host: ${yandex_compute_instance.vsnk.network_interface.0.nat_ip_address}
    mysql:
      hosts:
        db01:
          ansible_host: ${yandex_compute_instance.db01.network_interface.0.nat_ip_address}
          mysql_replication_role: 'master'
        db02:
          ansible_host: ${yandex_compute_instance.db02.network_interface.0.nat_ip_address}
          mysql_replication_role: 'slave'
    app:
      hosts:
        app:
          ansible_host: ${yandex_compute_instance.app.network_interface.0.nat_ip_address}
          copy_id_rsa_pub: 'dst'
    gitlab:
      hosts:
        gitlab:
          ansible_host: ${yandex_compute_instance.gitlab.network_interface.0.nat_ip_address}
    runner:
      hosts:
        runner:
          ansible_host: ${yandex_compute_instance.runner.network_interface.0.nat_ip_address}
          copy_id_rsa_pub: 'src'
    monitoring:
      hosts:
        monitoring:
          ansible_host: ${yandex_compute_instance.monitoring.network_interface.0.nat_ip_address}

    DOC
  filename = "../ansible/inventory"

  depends_on = [
    yandex_compute_instance.app,
    yandex_compute_instance.gitlab,
    yandex_compute_instance.monitoring,
    yandex_compute_instance.db01,
    yandex_compute_instance.db02,
    yandex_compute_instance.runner,
    yandex_compute_instance.vsnk
  ]
}