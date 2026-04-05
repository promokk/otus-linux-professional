# Настраиваем бэкапы

---
## Описание домашнего задания
Задание:  
Настроить удаленный бекап каталога /etc c сервера client при помощи borgbackup. Резервные копии должны соответствовать следующим критериям:
* директория для резервных копий /var/backup. Это должна быть отдельная точка монтирования. В данном случае для демонстрации размер не принципиален, достаточно будет и 2GB;
* репозиторий дле резервных копий должен быть зашифрован ключом или паролем - на ваше усмотрение;
* имя бекапа должно содержать информацию о времени снятия бекапа;
* глубина бекапа должна быть год, хранить можно по последней копии на конец месяца, кроме последних трех.
Последние три месяца должны содержать копии на каждый день. Т.е. должна быть правильно настроена политика удаления старых бэкапов;
* резервная копия снимается каждые 5 минут. Такой частый запуск в целях демонстрации;
* написан скрипт для снятия резервных копий. Скрипт запускается из соответствующей Cron джобы, либо systemd timer-а - на ваше усмотрение;
* настроено логирование процесса бекапа. Для упрощения можно весь вывод перенаправлять в logger с соответствующим тегом. Если настроите не в syslog, то обязательна ротация логов.

---
## Решение

Основные команды:  
~~~shell
// Установить на оба сервера borgbackup
apt install borgbackup

// Настройка backup-сервер
создаем пользователя и каталог
mkdir /var/backup
mkfs.ext4 /dev/sdb
mount -t ext4 /dev/sdb /var/backup

sudo useradd borg
sudo mkhomedir_helper borg
echo "borg:123456" | sudo chpasswd
chown borg:borg /var/backup/

// Создать каталог
su - borg
mkdir .ssh
touch .ssh/authorized_keys
chmod 700 .ssh
chmod 600 .ssh/authorized_keys


// Настройка client-сервер
ssh-keygen
ssh-copy-id borg@192.168.1.104

// Инициализация репозитория borg на backup-сервере с client-сервера
borg init --encryption=repokey borg@192.168.1.104:/var/backup/

// Запустить для проверки создание бэкапа
borg create --stats --list \
  borg@192.168.1.104:/var/backup/::"etc-{now:%Y-%m-%d_%H-%M-%S}" /etc

// Проверка
borg list borg@192.168.1.104:/var/backup/
borg list borg@192.168.1.104:/var/backup/::etc-2026-04-02_20-38-09

// Достать файл из бекапа
borg extract \
  borg@192.168.1.104:/var/backup/::etc-2026-04-02_20-38-09 

// Автоматизировать создание бэкапов с помощью systemd
nano /etc/systemd/system/borg-backup.service

nano /etc/systemd/system/borg-backup.timer

// Включить и запустить службу таймера
systemctl enable borg-backup.timer 
systemctl start borg-backup.timer

// Проверить работу таймера
systemctl list-timers --all
~~~

Скриншоты результата:  
![01 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-18/data/01.png)  
![02 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-18/data/02.png)  
![03 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-18/data/03.png)
