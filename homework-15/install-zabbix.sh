#!/bin/bash

# Пример выполнения скрипта:
# sudo bash install-zabbix.sh

# После установки фронт zabbix доступен по адресу:
# http://{ip}:8080/setup.php

# Документация
# https://www.zabbix.com/download

# Установить репозиторий Zabbix
wget https://repo.zabbix.com/zabbix/7.4/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.4+ubuntu22.04_all.deb
dpkg -i zabbix-release_latest_7.4+ubuntu22.04_all.deb

# Установить Zabbix сервер, фронт, агент, БД(по необходимости)
apt update
apt install zabbix-server-pgsql zabbix-frontend-php php8.1-pgsql zabbix-nginx-conf zabbix-sql-scripts zabbix-agent postgresql

# Создать исходную базу данных
sudo -u postgres createuser --pwprompt zabbix
sudo -u postgres createdb -O zabbix zabbix
# На сервере Zabbix импортируйте исходную схему и данные.
zcat /usr/share/zabbix/sql-scripts/postgresql/server.sql.gz | sudo -u zabbix psql zabbix

# Настройка базы данных для Zabbix-сервера
sed -i -e "s@# DBPassword=@DBPassword=123456@g" /etc/zabbix/zabbix_server.conf
# Настройка PHP для фронта Zabbix
sed -i -e "s@#        listen          8080;@        listen          8080;@g;
		s@#        server_name     example.com;@        server_name     example.com;@g" /etc/zabbix/nginx.conf

# Запуск процессов сервера и агента Zabbix
systemctl restart zabbix-server zabbix-agent nginx php8.1-fpm
systemctl enable zabbix-server zabbix-agent nginx php8.1-fpm

