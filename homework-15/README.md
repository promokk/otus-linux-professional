# Практика c SELinux

---
## Описание домашнего задания
Задание:  
1. Настроить дашборд с 4-мя графиками:
* память;
* процессор;
* диск;
* сеть.
2. Настроить на одной из систем:
* zabbix (использовать screen (комплексный экран);
* prometheus - grafana.

---
## Решение

Основные команды:  
~~~shell
// Установить Zabbix
bash install-zabbix.sh

// Настройка, открыть web-страницу Zabbix
http://{ip}:8080
~~~

Скриншоты результата:  
![01 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-15/data/01.png)
