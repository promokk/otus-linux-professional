# Занятие 1. Обновление ядра системы

---
## Описание домашнего задания
1) Запустить ВМ c Ubuntu.
2) Обновить ядро ОС на новейшую стабильную версию из mainline-репозитория.
3) Оформить отчет в README-файле в GitHub-репозитории.

---
## Решение
[Репозиторий версий ядра](https://kernel.ubuntu.com/mainline)  

Основные команды:  
~~~shell
uname -r
mkdir kernel && cd kernel
wget https://kernel.ubuntu.com/mainline/v6.17.7/amd64/linux-headers-6.17.7-061707-generic_6.17.7-061707.202511021342_amd64.deb
wget https://kernel.ubuntu.com/mainline/v6.17.7/amd64/linux-headers-6.17.7-061707_6.17.7-061707.202511021342_all.deb
wget https://kernel.ubuntu.com/mainline/v6.17.7/amd64/linux-image-unsigned-6.17.7-061707-generic_6.17.7-061707.202511021342_amd64.deb
wget https://kernel.ubuntu.com/mainline/v6.17.7/amd64/linux-modules-6.17.7-061707-generic_6.17.7-061707.202511021342_amd64.deb
sudo dpkg -i *.deb
ls -al /boot
sudo update-grub
sudo grub-set-default 0
sudo reboot
~~~

Скриншоты результата:  
![01 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-01/data/01.png)  
![02 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-01/data/02.png)  
![03 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-01/data/03.png)  
![04 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-01/data/04.png)  
![05 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-01/data/05.png)
