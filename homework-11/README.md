# Практика c SELinux

---
## Описание домашнего задания
Задание:
1. Запустить Nginx на нестандартном порту 3-мя разными способами:
   * переключатели setsebool;
   * добавление нестандартного порта в имеющийся тип;
   * формирование и установка модуля SELinux.
2. Обеспечить работоспособность приложения при включенном selinux.
   * развернуть приложенный стенд https://github.com/Nickmob/vagrant_selinux_dns_problems;
   * выяснить причину неработоспособности механизма обновления зоны (см. README);
   * предложить решение (или решения) для данной проблемы;
   * выбрать одно из решений для реализации, предварительно обосновав выбор;
   * реализовать выбранное решение и продемонстрировать его работоспособность.

---
## Решение

Основные команды:  
~~~shell
// Подготовка окружения
sudo apt update && sudo apt install vagrant
sudo apt-get install libvirt-daemon-system
sudo apt install selinux-utils

// Изменить /etc/nginx/nginx.conf
http {
        server {
                listen 4881;
                server_name _;
                location / {
                        return 404;
                }
        }
        ...
// end

~~~

Скриншоты результата:  
![01 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-10/data/01.png)
