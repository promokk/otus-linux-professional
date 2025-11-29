# GRUB

---
## Описание домашнего задания
* Включить отображение меню Grub. 
* Попасть в систему без пароля несколькими способами. 
* Установить систему с LVM, после чего переименовать VG.

---
## Решение

Основные команды:  
~~~shell
// Включить отображение меню Grub
nano /etc/default/grub
// #GRUB_TIMEOUT_STYLE=hidden
// GRUB_TIMEOUT=10
update-grub
reboot

// Попасть в систему без пароля несколькими способами
// Выполнение работы изображено на картинке 2 - 4

// Установить систему с LVM, после чего переименовать VG
vgs
vgrename ubuntu-vg ubuntu-otus
sed -i 's/ubuntu--vg/ubuntu--otus/g' /boot/grub/grub.cfg
reboot
~~~

Скриншоты результата:  
![01 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-07/data/01.png)  
![02 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-07/data/02.png)  
![03 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-07/data/03.png)  
![04 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-07/data/04.png)  
![05 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-07/data/05.png)  
![06 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-07/data/06.png)  
![07 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-07/data/07.png)  
![08 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-07/data/08.png)
