# Local .terraform directories

## **/.terraform/*

Игнорировать все файлы папки .terragorm находящейся во всех подпапках


# .tfstate files

## *.tfstate

Игнорировать все файлы вида любое_количество_символов.tfstate

## *.tfstate.*

Игнорировать все файлы вида любое_количество_символов.tfstate.любое_количество_символов


# Crash log files

## crash.log

Игнорировать файл crash.log

# Exclude all .tfvars files, which are likely to contain sentitive data, such as
# password, private keys, and other secrets. These should not be part of version
# control as they are data points which are potentially sensitive and subject
# to change depending on the environment.

## *.tfvars

Игнорировать все файлы вида любое_количество_символов.tfvars


# Ignore override files as they are usually used to override resources locally and so
# are not checked in

## override.tf

Игнорировать файл override.tf

## override.tf.json

Игнорировать файл override.tf.json

## *_override.tf

Игнорировать файлы вида любое_количество_символов_override.tf

## *_override.tf.json

Игнорировать файлы вида любое_количество_символов_override.tf.json


# Include override files you do wish to add to version control using negated pattern

## !example_override.tf

Включать файл example_override.tf не смотря на игнорирование файлов вида любое_количество_символов_override.tf.json


# Ignore CLI configuration files

## .terraformrc

Игнорировать файл .terraformrc

## terraform.rc

Игнорировать файл terraform.rc