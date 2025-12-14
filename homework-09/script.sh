#!/bin/bash

# Путь до файла с логами
logFileAcc='/var/log/nginx/access.log'
logFileErr='/var/log/nginx/error.log'

# дата старта веб-сервера
startDateWebServer=$(systemctl status nginx | grep "Active:" | date -d $(awk '{print $6}') +'%Y-%m-%d')
# время старта веб-сервера
startTimeWebServer=$(systemctl status nginx | grep "Active:" | date -d $(awk '{print $7}') +'%H:%M:%S')
# дата+время в формате Unix
startDate=$(date -d "${startDateWebServer}T${startTimeWebServer}" +%s)

echo 'Топ 10. IP-адреса с наибольшим числом запросов (с момента последнего запуска)'
awk -v startDate="$startDate" '{
    cmd = "date -d \"" $4 "\" +%s";
    cmd | getline result;
    close(cmd);
    if (result >= startDate) { print $1 };
}' $logFileAcc | sort | uniq -c | sort -nr | head -10

echo 'Топ 10. Запрашиваемые URL с наибольшим числом запросов (с момента последнего запуска)'
awk -v startDate="$startDate" '{
    cmd = "date -d \"" $4 "\" +%s";
    cmd | getline result;
    close(cmd);
    if (result >= startDate) { print $6 };
}' $logFileAcc | sort | uniq -c | sort -nr | head -10

echo 'Топ 10. HTTP-коды ответов с указанием их количества (с момента последнего запуска)'
awk -v startDate="$startDate" '{
    cmd = "date -d \"" $4 "\" +%s";
    cmd | getline result;
    close(cmd);
    if (result >= startDate) { print $8 };
}' $logFileAcc | sort | uniq -c | sort -nr | head -10

echo 'Ошибки веб-сервера/приложения (с момента последнего запуска)'
awk -v startDate="$startDate" '{
    cmd = "date -d \"" $1" "$2 "\" +%s";
    cmd | getline result;
    close(cmd);
    if (result >= startDate) { print $0 };
}' $logFileErr
