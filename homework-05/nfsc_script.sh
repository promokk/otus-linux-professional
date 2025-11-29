#!/bin/bash

# Пример выполнения скрипта:
# sudo bash nfss_script.sh {ip_server}

# Параметры
# IP сервера NFS
ip_server=$1

# Установим пакет с NFS-клиентом
apt install nfs-common

# Добавляем в /etc/fstab строку
echo "${ip_server}:/srv/share/ /mnt nfs vers=3,noauto,x-systemd.automount 0 0" >> /etc/fstab

# Перезапускаем сервис
systemctl daemon-reload
systemctl restart remote-fs.target

# Проверка
cd /mnt
mount | grep mnt
