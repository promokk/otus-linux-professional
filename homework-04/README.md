# Стенд ZFS

---
## Описание домашнего задания
* Определить алгоритм с наилучшим сжатием:
  * определить какие алгоритмы сжатия поддерживает zfs (gzip, zle, lzjb, lz4);
  * создать 4 файловых системы на каждой применить свой алгоритм сжатия;
  * для сжатия использовать либо текстовый файл, либо группу файлов.
* Определить настройки пула.  
С помощью команды zfs import собрать pool ZFS.  
Командами zfs определить настройки:
  * размер хранилища; 
  * тип pool; 
  * значение recordsize; 
  * какое сжатие используется; 
  * какая контрольная сумма используется.
* Работа со снапшотами:
  * скопировать файл из удаленной директории;
  * восстановить файл локально. zfs receive;
  * найти зашифрованное сообщение в файле secret_message.


---
## Решение

Основные команды:  
~~~shell
// Определение алгоритма с наилучшим сжатием
apt install zfsutils-linux
zpool create otus1 mirror /dev/sdb /dev/sdc
zpool create otus2 mirror /dev/sdd /dev/sde
zpool create otus3 mirror /dev/sdf /dev/sdg
zpool create otus4 mirror /dev/sdh /dev/sdi
zfs set compression=lzjb otus1
zfs set compression=lz4 otus2
zfs set compression=gzip-9 otus3
zfs set compression=zle otus4
zfs get all | grep compression
for i in {1..4}; do wget -P /otus$i https://gutenberg.org/cache/epub/2600/pg2600.converter.log; done
ls -l /otus*
zfs list
zfs get all | grep compressratio | grep -v ref

// Определение настроек пула
wget -O archive.tar.gz --no-check-certificate 'https://drive.usercontent.google.com/download?id=1MvrcEp-WgAQe57aDEzxSRalPAwbNN1Bb&export=download'
tar -xzvf archive.tar.gz
zpool import -d zpoolexport/
zpool import -d zpoolexport/ otus
zpool status otus
zfs get all otus
zfs get available otus
zfs get readonly otus
zfs get recordsize otus
zfs get compression otus
zfs get checksum otus

// Работа со снапшотом, поиск сообщения от преподавателя
wget -O otus_task2.file --no-check-certificate https://drive.usercontent.google.com/download?id=1wgxjih8YZ-cqLqaZVa0lA3h3Y029c3oI&export=download
zfs receive otus/test@today < otus_task2.file
find /otus/test -name "secret_message"
cat /otus/test/task1/file_mess/secret_message
~~~

Скриншоты результата:  
![01 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-04/data/01.png)  
![02 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-04/data/02.png)  
![03 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-04/data/03.png)  
![04 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-04/data/04.png)  
![05 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-04/data/05.png)  
![06 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-04/data/06.png)  
![07 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-04/data/07.png)  
![08 - картинка](https://raw.githubusercontent.com/promokk/otus-linux-professional/main/homework-04/data/08.png)
