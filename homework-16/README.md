# Авторизация и аутентификация РАМ

---
## Описание домашнего задания
Задание:  
1. Ограничить доступ к системе для всех пользователей, кроме группы администраторов, 
в выходные дни (суббота и воскресенье), за исключением праздничных дней.
---
## Решение

Основные команды:  
~~~shell
// Изменить оболочку по умолчанию
sudo chsh -s /bin/bash

// Создать пользователей
sudo useradd userAdm && sudo useradd user01

// Создать домашний каталог
sudo mkhomedir_helper userAdm && sudo mkhomedir_helper user01

// Добавить пароль
echo "userAdm:123456" | sudo chpasswd && echo "user01:123456" | sudo chpasswd

// Создать группу
sudo groupadd -f adminGrp

// Добавить пользователей в группу 
usermod userAdm -a -G adminGrp && usermod root -a -G adminGrp

// Создать файл-скрипт /usr/local/bin/login.sh
nano /usr/local/bin/login.sh

// Добавить права на исполнение файла
chmod +x /usr/local/bin/login.sh

// Указать в файле /etc/pam.d/sshd модуль pam_exec и скрипт login.sh
nano /etc/pam.d/sshd
"""
auth required pam_exec.so debug /usr/local/bin/login.sh
"""

// Проверка. Изменить дату на 2022 год, выходной день
sudo date -s "2022-08-27 $(date +%H:%M:%S)"
// Вход под пользователем user01
~~~

Скриншоты результата:  
![01 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-16/data/01.png)
