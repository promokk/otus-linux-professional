# Практика c Ansible

---
## Описание домашнего задания
Задание:  
1. Используя Ansible, необходимо развернуть nginx со следующими условиями:
* необходимо использовать модуль yum/apt;
* конфигурационные файлы должны быть взяты из шаблона jinja2 с переменными;
* после установки nginx должен быть в режиме enabled в systemd;
* должен быть использован notify для старта nginx после установки;
* сайт должен слушать на нестандартном порту — 8080, для этого использовать переменные в Ansible.

---
## Решение

Основные команды:  
~~~shell
// Подготовка окружения
sudo apt update && sudo apt install ansible

// Подготовка ssh ключей
ssh-keygen
ssh-copy-id andrey@192.168.1.110

// Проверка
ansible nginx -i inventory-host -m ping

// Создать ./inventory-host
// ansible_become_pass - пароль для sudo. Небезопасно!
[web]
nginx ansible_host=192.168.1.110 ansible_port=22 ansible_become_pass=123456
ansible_private_key_file=/home/andrey/.ssh/id_rsa
// end

// Создать ./ansible.cfg
[defaults]
inventory = inventory-host
remote_user = andrey
host_key_checking = False
retry_files_enabled = False
// end

// Создать ./templates/nginx.conf.j2
events {
    worker_connections 1024;
}

http {
    server {
        listen       {{ nginx_listen_port }} default_server;
        server_name  default_server;
        root         /usr/share/nginx/html;

        location / {
        }
    }
}
// end

// Создать ./nginx.yml
// Файл доступен в репозитории

// Запустить playbook
ansible-playbook nginx.yml

// Проверка
curl http://192.168.1.110:8080
~~~

Скриншоты результата:  
![01 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-12/data/01.png)  
![02 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-12/data/02.png)  
![03 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-12/data/03.png)
