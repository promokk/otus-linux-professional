# Работа с LVM

---
## Описание домашнего задания
* Уменьшить том под / до 8G.
* Выделить том под /home.
* Выделить том под /var - сделать в mirror.
* /home - сделать том для снапшотов.
* Прописать монтирование в fstab. Попробовать с разными опциями и разными файловыми системами (на выбор).
* Работа со снапшотами:
  * сгенерить файлы в /home/;
  * снять снапшот;
  * удалить часть файлов;
  * восстановиться со снапшота.

---
## Решение
 

Основные команды:  
~~~shell
// Уменьшить том под / до 8G
pvcreate /dev/sdc
vgcreate vg_root /dev/sdc
lvcreate -n lv_root -L 8G /dev/vg_root
mkfs.ext4 /dev/vg_root/lv_root
mkdir /mnt/root
mount /dev/vg_root/lv_root /mnt/root
rsync -avxHAX --progress / /mnt/root/
for i in /proc/ /sys/ /dev/ /run/ /boot/; do sudo mount --bind "$i" "/mnt/root/$i"; done
sudo chroot /mnt/root/
grub-mkconfig -o /boot/grub/grub.cfg
update-initramfs -u
reboot

// Выделить том под /var - сделать в mirror (зеркало)
pvcreate /dev/sdb /dev/sdd
vgcreate vg_var /dev/sdb /dev/sdd
lvcreate -L 1G -m1 -n lv_var vg_var
mkfs.ext4 /dev/vg_var/lv_var
mkdir /mnt/var
mount /dev/vg_var/lv_var /mnt/var
cp -aR /var/* /mnt/var
mkdir /tmp/oldvar && mv /var/* /tmp/oldvar
umount /mnt/var
mount /dev/vg_var/lv_var /var
echo "`blkid | grep var: | awk '{print $2}'` /var ext4 defaults 0 0" >> /etc/fstab

// /home - сделать том для снапшотов
lvcreate -L 1G -m1 -n lv_home vg_var
mkfs.ext4 /dev/vg_var/lv_home
mkdir /mnt/home
mount /dev/vg_var/lv_home /mnt/home
cp -aR /home/* /mnt/home
mkdir /tmp/oldhome && mv /home/* /tmp/oldhome
umount /mnt/home
mount /dev/vg_var/lv_home /home
echo "`blkid | grep home: | awk '{print $2}'` /home ext4 defaults 0 0" >> /etc/fstab

// Работа со снапшотами
touch /home/file{1..20}
lvcreate -L 100MB -s -n home_snap /dev/vg_var/lv_home
rm -f /home/file{11..20}
umount /home
lvconvert --merge /dev/vg_var/home_snap
mount /dev/mapper/vg_var-lv_home /home
~~~

Скриншоты результата:  
![01 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-03/data/01.png)  
![02 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-03/data/02.png)  
![03 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-03/data/03.png)  
![04 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-03/data/04.png)  
![05 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-03/data/05.png)  
