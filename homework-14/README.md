# Практика c SELinux

---
## Описание домашнего задания
Задание:  
* Создайте свой кастомный образ nginx на базе alpine. После запуска nginx должен отдавать кастомную страницу 
(достаточно изменить дефолтную страницу nginx)

---
## Решение

Основные команды:  
~~~shell
// Установить Docker
bash install-docker.sh ./dockerDir

// Создать Image
sudo docker build -f dockerfile-nginx . -t nginx-image:latest

// Создать Сontainer
sudo docker run --name nginx-container -p 8080:80 -d nginx-image:latest

// Проверка
curl http://127.0.0.1:8080
~~~

Скриншоты результата:  
![01 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-14/data/01.png)  
![02 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-14/data/02.png)  
![03 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-14/data/03.png)
