#!/bin/bash

# Пример выполнения скрипта:
# sudo bash nfss_script.sh {ip_client}

# Параметры
# IP клиента NFS
ip_client=$1

# Установим сервер NFS
apt install nfs-kernel-server

# Создаём и настраиваем директорию, которая будет экспортирована в будущем
cd /etc
mkdir -p /srv/share/upload
chown -R nobody:nogroup /srv/share
chmod 0777 /srv/share/upload

# Cоздаём в файле /etc/exports структуру, которая позволит экспортировать ранее созданную директорию
cat << EOF > /etc/exports 
/srv/share ${ip_client}/32(rw,sync,root_squash)
EOF

# Экспортируем ранее созданную директорию
exportfs -r

# Проверяем экспортированную директорию
exportfs -s
