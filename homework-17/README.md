# Rsyslog и Audit

---
## Описание домашнего задания
Задание:  
1. Разворачиваем 2 виртуальные машины web и log
2. на web настраиваем nginx
3. на log настраиваем центральный лог сервер на любой системе на выбор
* journald;
* rsyslog;
* elk.
4. настраиваем аудит, следящий за изменением конфигов nginx

Все критичные логи с web должны собираться и локально и удаленно.
Все логи с nginx должны уходить на удаленный сервер (локально только критичные).
Логи аудита должны также уходить на удаленную систему.

---
## Решение

Основные команды:  
~~~shell
// Настройка log-сервера
nano /etc/rsyslog.conf
"""
# provides UDP syslog reception
module(load="imudp")
input(type="imudp" port="514")

# provides TCP syslog reception
module(load="imtcp")
input(type="imtcp" port="514")

# Add remote logs
$template RemoteLogs,"/var/log/rsyslog/%HOSTNAME%/%PROGRAMNAME%.log"
*.* ?RemoteLogs
& ~
"""
systemctl restart rsyslog

// Настройка auditd на log-сервера
apt install audispd-plugins

nano /etc/audit/auditd.conf
"""
tcp_listen_port = 60
"""

// Настройка web-сервера
nano /etc/nginx/nginx.conf
"""
error_log /var/log/nginx/error.log;
error_log syslog:server=192.168.1.109:514,tag=nginx_error;
access_log syslog:server=192.168.1.109:514,tag=nginx_access,severity=info combined;
"""

systemctl restart nginx

// Настройка auditd на web-сервере
apt install audispd-plugins

nano /etc/audit/rules.d/audit.rules
"""
-w /etc/nginx/nginx.conf -p wa -k nginx_conf
-w /etc/nginx/default.d/ -p wa -k nginx_conf
"""

nano /etc/audit/auditd.conf
"""
log_format = RAW
name_format = HOSTNAME
"""

nano /etc/audit/plugins.d/au-remote.conf
"""
active = yes
"""

nano /etc/audit/audisp-remote.conf
"""
remote_server = 192.168.1.109
"""

systemctl restart auditd
~~~

Скриншоты результата:  
![01 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-17/data/01.png)  
![02 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-17/data/02.png)  
![03 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-17/data/03.png)
