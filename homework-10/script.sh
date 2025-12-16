#!/bin/bash

procArr=$(ls /proc/ | grep -E '^[0-9]+$')
HZ=$(getconf CLK_TCK)

# Заголовок
echo "PID TTY      STAT   TIME COMMAND"

for pid in ${procArr[@]}
do

# Проверка
if [ $(ls /proc | grep -ci $pid) -eq 0 ]; then
    continue
fi

# TTY
tty="?"

# STAT
stat=$(awk '{print $3}' /proc/$pid/stat)
if [ $pid -eq $(awk '{print $5}' /proc/$pid/stat) ]; then
    stat+="s"
fi
if [ $(ls /proc/$pid/task | wc -l) -gt 1 ]; then
    stat+="l"
fi

# COMMAND
command=$(cat /proc/$pid/cmdline | tr '\0' ' ')
if [ -z "$command" ]; then
    command=$(awk '{print $2}' /proc/$pid/stat)
    command="$(echo "$command" | sed 's/(/[/' | sed 's/)/]/')"
fi

# TIME
total_seconds=$(($(awk '{print $14+$15}' /proc/$pid/stat) / $HZ))
hours=$((total_seconds / 3600))
minutes=$(((total_seconds % 3600) / 60))
remaining_seconds=$((total_seconds % 60))
formatted_time=""
if ((hours > 0)); then
    formatted_time+="${hours}:"
fi
formatted_time+="${minutes}:${remaining_seconds}"

# Результат
echo "$pid $tty      $stat   $formatted_time $command"
done