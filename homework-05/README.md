# Работа с NFS

---
## Описание домашнего задания
Основная часть:
* запустить 2 виртуальных машины (сервер NFS и клиента);
* на сервере NFS должна быть подготовлена и экспортирована директория;
*  экспортированной директории должна быть поддиректория с именем upload с правами на запись в неё;
* экспортированная директория должна автоматически монтироваться на клиенте при старте виртуальной машины 
(systemd, autofs или fstab — любым способом);
* монтирование и работа NFS на клиенте должна быть организована с использованием NFSv3.

---
## Решение
Bash-скрипты:
* nfss_script.sh - для конфигурирования сервера
* nfsc_script.sh - для конфигурирования клиента

Основные команды:  
~~~shell
// Сервер
apt install nfs-kernel-server
cd /etc
mkdir -p /srv/share/upload
chown -R nobody:nogroup /srv/share
chmod 0777 /srv/share/upload
cat << EOF > /etc/exports 
/srv/share 192.168.1.111/32(rw,sync,root_squash)
EOF
exportfs -r
exportfs -s


// Клиент
apt install nfs-common
echo "192.168.1.110:/srv/share/ /mnt nfs vers=3,noauto,x-systemd.automount 0 0" >> /etc/fstab
systemctl daemon-reload
systemctl restart remote-fs.target
cd /mnt
mount | grep mnt
~~~

Скриншоты результата:  
![01 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-05/data/01.png)   
![02 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-05/data/02.png)
