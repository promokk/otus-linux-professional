# Работа с mdadm

---
## Описание домашнего задания
* Добавить в виртуальную машину несколько дисков
* Собрать RAID-0/1/5/10 на выбор
* Сломать и починить RAID
* Создать GPT таблицу, пять разделов и смонтировать их в системе

---
## Решение
 

Основные команды:  
~~~shell
// Добавить в виртуальную машину несколько дисков
lsblk
fdisk -l
fdisk -l /dev/sdb
fdisk /dev/sdb

// Собрать RAID-0/1/5/10 — на выбор
mdadm --create /dev/md127 -l 1 -n 2 /dev/sdb1 /dev/sdb2
sudo mdadm -D /dev/md127
cat /proc/mdstat

sudo mkfs.ext4 /dev/md127
mkdir /mnt/01
mount /dev/md127 /mnt/01
df -hT

cp -r /var/log/* /mnt/01
ls -al /mnt/01
rm -r /mnt/01/*
umount /mnt/01

// Сломать и починить RAID
cat /proc/mdstat
mdadm /dev/md127 --fail /dev/sdb2
cat /proc/mdstat
mdadm /dev/md127 --remove /dev/sdb2
mdadm /dev/md127 --add /dev/sdb2
cat /proc/mdstat

// Создать GPT таблицу, пять разделов и смонтировать их в системе
parted -s /dev/md127 mklabel gpt
parted /dev/md127 mkpart primary ext4 0% 20%
parted /dev/md127 mkpart primary ext4 20% 40%
parted /dev/md127 mkpart primary ext4 40% 60%
parted /dev/md127 mkpart primary ext4 60% 80%
parted /dev/md127 mkpart primary ext4 80% 100%
for i in $(seq 1 5); do sudo mkfs.ext4 /dev/md127p$i; done
mkdir -p /raid/part{1,2,3,4,5}
for i in $(seq 1 5); do mount /dev/md127p$i /raid/part$i; done
df -h
~~~

Скриншоты результата:  
![01 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-02/data/01.png)  
![02 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-02/data/02.png)  
![03 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-02/data/03.png)  
![04 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-02/data/04.png)  
![05 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-02/data/05.png)
