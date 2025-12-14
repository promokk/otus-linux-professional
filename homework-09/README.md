# Bash-скрипт

---
## Описание домашнего задания
Написать bash-скрипт, который ежечасно формирует и отправляет на email отчёт о работе веб-сервера.  
Написать скрипт для CRON, который раз в час формирует отчёт и отправляет его на заданную почту.  
Отчёт должен содержать:
* IP-адреса с наибольшим числом запросов (с момента последнего запуска);
* Запрашиваемые URL с наибольшим числом запросов (с момента последнего запуска);
* Ошибки веб-сервера/приложения (с момента последнего запуска);
* HTTP-коды ответов с указанием их количества (с момента последнего запуска).

---
## Решение

Основные команды:  
~~~shell
// Установка Nginx 
sudo apt install nginx
sudo systemctl enable nginx
sudo nano /etc/nginx/nginx.conf
// меняем формат даты в логах
http {
    ...
    log_format custom '$remote_addr - $remote_user $time_iso8601 "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent"';
   
    access_log /var/log/nginx/access.log custom_access;
   ...
}
// end
sudo systemctl restart nginx

crontab -e
// Добавляем правило
@hourly /home/andrey/script.sh
// Посмотреть логи
grep CRON /var/log/syslog
~~~

Скриншоты результата:  
![01 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-09/data/01.png)  
![02 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-09/data/02.png)
