# Systemd - создание unit-файла

---
## Описание домашнего задания
* Написать service, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова 
(файл лога и ключевое слово должны задаваться в /etc/default).
* Установить spawn-fcgi и создать unit-файл (spawn-fcgi.sevice) с помощью переделки init-скрипта 
(https://gist.github.com/cea2k/1318020).
* Доработать unit-файл Nginx (nginx.service) для запуска нескольких инстансов сервера с разными конфигурационными 
файлами одновременно.

---
## Решение

Основные команды:  
~~~shell
// Написать service, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова
// Файл с конфигурацией для сервиса в директории /etc/default - из неё сервис будет брать необходимые переменные.
touch /etc/default/watchlog
// Создаем /var/log/watchlog.log и пишем туда строки на своё усмотрение, плюс ключевое слово ‘ALERT’
touch /var/log/watchlog.log
// Создадим скрипт
cat > /opt/watchlog.sh
chmod +x /opt/watchlog.sh
// Создадим юнит для сервиса
cat > /etc/systemd/system/watchlog.service
// Создадим юнит для таймера
cat > /etc/systemd/system/watchlog.timer
// Достаточно запустить только timer, что заработал таймер и сервис
systemctl daemon-reload
systemctl start watchlog.timer
// Проверка
tail -n 100 /var/log/syslog | grep word

// Установить spawn-fcgi и создать unit-файл (spawn-fcgi.sevice) с помощью переделки init-скрипта
// Устанавливаем spawn-fcgi и необходимые для него пакеты
apt install spawn-fcgi php php-cgi php-cli \
apache2 libapache2-mod-fcgid -y
// необходимо создать файл с настройками для будущего сервиса в файле /etc/spawn-fcgi/fcgi.conf
mkdir /etc/spawn-fcgi
cat > /etc/spawn-fcgi/fcgi.conf
// Создадим юнит для сервиса
cat > /etc/systemd/system/spawn-fcgi.service
// Запускаем
systemctl daemon-reload
systemctl start spawn-fcgi
systemctl status spawn-fcgi

// Доработать unit-файл Nginx (nginx.service) для запуска нескольких инстансов сервера с разными конфигурационными файлами одновременно
// Установим Nginx из стандартного репозитория
apt install nginx -y
// Создадим новый Unit для работы с шаблонами (/etc/systemd/system/nginx@.service)
cat > /etc/systemd/system/nginx@.service
// Необходимо создать два файла конфигурации
cat /etc/nginx/nginx.conf > /etc/nginx/nginx-first.conf
cat /etc/nginx/nginx.conf > /etc/nginx/nginx-second.conf
// Запускаем
systemctl daemon-reload
systemctl start nginx@first
systemctl start nginx@second
// Проверка
ss -tnulp | grep nginx
ps afx | grep nginx
~~~

Скриншоты результата:  
![01 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-08/data/01.png)
![02 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-08/data/02.png)
![03 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-08/data/03.png)
![04 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-08/data/04.png)
![05 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-08/data/05.png)
![06 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-08/data/06.png)
![07 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-08/data/07.png)
![08 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-08/data/08.png)
![09 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-08/data/09.png)
![10 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-08/data/10.png)
![11 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-08/data/11.png)
![12 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-08/data/12.png)
