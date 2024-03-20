#!/bin/bash

#запрашиваем интервал времени, благодаря которому будем искать нужные файлы для удаления
. ./part3_user_interval.sh
REMOVED_FILES=0
FS_NAME=$(df / -h | tail -1 | awk '{printf $1}')
echo -e ${RED}"Состояние памяти до удаления: $(df -h | awk '$6=="/"{print $4}')"

#находим все папки в текущей файловой системе, кроме bin и sbin, и только те, что доступны для записи
for entry_folder in $(sudo find / -mount ! -wholename '\/usr\/bin*' ! -wholename '\/usr\/sbin*' -type d -perm /u=w); do

    #проверяем время создания каждого файла во входящей папке
    for entry in $(sudo find ${entry_folder} -maxdepth 1 -type f 2> /dev/null); do
        FILE_INDEX=$(sudo ls -i $entry 2> /dev/null | awk '{printf $1}')
        FULL_DATE=$(sudo debugfs -R 'stat <'"$FILE_INDEX"'>' "$FS_NAME" 2> /dev/null | grep crtime: | cut -d " " -f 4-)
        ANALIZE_FILE_DATE=$(date -d "$(date -d "$FULL_DATE" +"%Y"-"%m"-"%d %T")" +"%s")
        if [[ "$ANALIZE_FILE_DATE" -ge "$SPECIFIED_DATE_START" && "$ANALIZE_FILE_DATE" -le "$SPECIFIED_DATE_END" ]]; then
            sudo rm -f $entry
            ((++FILES_REMOVED))
        fi
    done
done

echo -e ${GREEN}"Состояние памяти после удаления: $(df -h | awk '$6=="/"{print $4}')"
echo -e "Файлов удалено: ${FILES_REMOVED}." 
echo -e ${RED}"Внимание!${GREEN} Папки не были удалены, их можно удалить при помощи скрипта с параметром 3, который вызывает часть скрипта, удаляющую файлы и папки по маске имени!"${NC}
