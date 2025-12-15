# Сборка RPM-пакета и создание репозитория

---
## Описание домашнего задания
* Создать свой RPM пакет (можно взять свое приложение, либо собрать, например, Apache с определенными опциями).
* Создать свой репозиторий и разместить там ранее собранный RPM.

Создал DEB пакет, так как использую Ubuntu.

---
## Решение

Основные команды:  
~~~shell
// Создать свой DEB пакет
echo '#!/bin/bash' > hello-world.sh
echo 'echo "Hello World!"' >> hello-world.sh
chmod +x hello-world.sh

mkdir -p hello-world/DEBIAN
mkdir -p hello-world/usr/bin
cp hello-world.sh hello-world/usr/bin/

cat << EOF > hello-world/DEBIAN/control
Package: hello-world
Version: 1.0
Architecture: amd64
Maintainer: Andrey <example@mail.ru>
Section: main
Priority: standard
Description: Simple Hello World application
EOF

dpkg-deb --build hello-world

// Создать свой репозиторий
sudo apt install reprepro
mkdir -p ~/my-repo/{conf,dists,incoming,pool}

cat << EOF > ~/my-repo/conf/distributions
Origin: My Local Repo
Label: My Local Repo
Codename: stable
Architectures: amd64 i386
Components: main contrib non-free
EOF

cp hello-world.deb ~/my-repo/incoming
reprepro includedeb stable ~/my-repo/incoming/hello-world.deb
// Проверяем
reprepro list stable

// Сделать доступным репозиторий для пользователя
sudo apt install nginx
sudo mkdir -p /var/www/html/my-repo
sudo cp -r ~/my-repo/* /var/www/html/my-repo
sudo nano /etc/nginx/sites-available/default
// start
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;

    server_name _;

    location /my-repo/ {
        alias /var/www/html/my-repo/;
        autoindex on;
        autoindex_exact_size off;
        autoindex_localtime on;
    }

    location / {
        try_files $uri $uri/ =404;
    }
}
// end

sudo systemctl restart nginx
~~~

Скриншоты результата:  
![01 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-06/data/01.png)
![02 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-06/data/02.png)
