# Настраиваем VPN

---
## Описание домашнего задания
1. Настроить VPN между двумя ВМ в tun/tap режимах, замерить скорость в туннелях, сделать вывод об отличающихся показателях.
2. Поднять RAS на базе OpenVPN с клиентскими сертификатами, подключиться с локальной машины на ВМ.


---
## Решение

Основные команды:  
~~~shell
# Установить нужные пакеты и отключаем SELinux  
apt update
apt install openvpn iperf3 selinux-utils
setenforce 0

# Настроить хост 1: 
# Создать файл-ключ 
openvpn --genkey secret /etc/openvpn/static.key
# Создать конфигурационный файл OpenVPN 
nano /etc/openvpn/server.conf

# Содержимое файла server.conf
dev tap 
ifconfig 10.10.10.1 255.255.255.0 
topology subnet 
secret /etc/openvpn/static.key 
comp-lzo 
status /var/log/openvpn-status.log 
log /var/log/openvpn.log  
verb 3

# Создать service unit для запуска OpenVPN
nano /etc/systemd/system/openvpn@.service

# Содержимое файла-юнита
[Unit] 
Description=OpenVPN Tunneling Application On %I 
After=network.target 
[Service] 
Type=notify 
PrivateTmp=true 
ExecStart=/usr/sbin/openvpn --cd /etc/openvpn/ --config %i.conf 
[Install] 
WantedBy=multi-user.target

# Хапустить сервис 
systemctl start openvpn@server 
systemctl enable openvpn@server


# Настроить хоста 2: 
# Создать конфигурационный файл OpenVPN 
nano /etc/openvpn/server.conf

# Содержимое конфигурационного файла  
dev tap 
remote 192.168.1.107 
ifconfig 10.10.10.2 255.255.255.0 
topology subnet 
route 192.168.1.0 255.255.255.0 
secret /etc/openvpn/static.key
comp-lzo
status /var/log/openvpn-status.log 
log /var/log/openvpn.log 
verb 3 

# На хост 2 в директорию /etc/openvpn необходимо скопировать файл-ключ static.key, который был создан на хосте 1. 
scp root@192.168.1.107:/etc/openvpn/static.key /etc/openvpn

# Создать service unit для запуска OpenVPN
nano /etc/systemd/system/openvpn@.service

# Содержимое файла-юнита
[Unit] 
Description=OpenVPN Tunneling Application On %I 
After=network.target 
[Service] 
Type=notify 
PrivateTmp=true 
ExecStart=/usr/sbin/openvpn --cd /etc/openvpn/ --config %i.conf 
[Install] 
WantedBy=multi-user.target

# Запустить сервис 
systemctl start openvpn@server 
systemctl enable openvpn@server



# Задание 2
# Установить необходимые пакеты 
apt update
apt install openvpn easy-rsa

# Перейти в директорию /etc/openvpn и инициализировать PKI
cd /etc/openvpn
/usr/share/easy-rsa/easyrsa init-pki
/usr/share/easy-rsa/easyrsa build-ca

# Генерация необходимых ключей и сертификатов для сервера 
echo 'rasvpn' | /usr/share/easy-rsa/easyrsa gen-req server nopass
echo 'yes' | /usr/share/easy-rsa/easyrsa sign-req server server 
/usr/share/easy-rsa/easyrsa gen-dh
openvpn --genkey secret ca.key

# Генерация необходимых ключей и сертификатов для клиента
echo 'client' | /usr/share/easy-rsa/easyrsa gen-req client nopass
echo 'yes' | /usr/share/easy-rsa/easyrsa sign-req client client

# Создать конфигурационный файл сервера 
nano /etc/openvpn/server.conf

port 1207 
proto udp 
dev tun 
ca /etc/openvpn/pki/ca.crt 
cert /etc/openvpn/pki/issued/server.crt 
key /etc/openvpn/pki/private/server.key 
dh /etc/openvpn/pki/dh.pem 
server 10.10.10.0 255.255.255.0 
ifconfig-pool-persist ipp.txt 
client-to-client 
client-config-dir /etc/openvpn/client 
keepalive 10 120 
comp-lzo 
persist-key 
persist-tun 
status /var/log/openvpn-status.log 
log /var/log/openvpn.log 
verb 3

# Создать параметр iroute для клиента
echo 'iroute 10.10.10.0 255.255.255.0' > /etc/openvpn/client/client

# Запустить сервис
systemctl start openvpn@server
systemctl enable openvpn@server

# На клиенте
nano /etc/openvpn/client.conf

dev tun 
proto udp 
remote 192.168.1.107 1207 
client 
resolv-retry infinite 
remote-cert-tls server 
ca ./ca.crt 
cert ./client.crt 
key ./client.key 
route 192.168.1.0 255.255.255.0 
persist-key 
persist-tun 
comp-lzo 
verb 3 

scp root@192.168.1.107:/etc/openvpn/pki/ca.crt /etc/openvpn
scp root@192.168.1.107:/etc/openvpn/pki/issued/client.crt /etc/openvpn
scp root@192.168.1.107:/etc/openvpn/pki/private/client.key /etc/openvpn

cd /etc/openvpn
openvpn --config client.conf

# Проверка
ping -c 4 10.10.10.1
~~~

Скриншоты результата:  
tap:  
![01 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-23/data/01.png)  
![02 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-23/data/02.png)

tun:  
![03 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-23/data/03.png)  
![04 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-23/data/04.png)

Задание №2:  
![05 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-23/data/05.png)  
![06 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-23/data/06.png)
