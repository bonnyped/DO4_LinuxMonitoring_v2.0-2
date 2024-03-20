#!/bin/bash

echo -e ${RED}"Состояние памяти до удаления: $(df -h | awk '$6=="/"{print $4}')"

while IFS= read -r entity; do
    ENTITY_NUM=$(ls $(echo $entity) 2>/dev/null | wc -l)
    ((FILES_REMOVED += $ENTITY_NUM))
    if [[ $(echo $entity | awk '{printf $1}') =~ \/$ ]]; then
        sudo rm -rf $(echo $entity | awk '{printf $1}') 2>/dev/null
    else
        break
    fi
done <file_generator.log

echo -e ${GREEN}"Состояние памяти после удаления: $(df -h | awk '$6=="/"{print $4}')"
rm -rf file_generator.log
echo -e "Файлов удалено и папок удалено: ${FILES_REMOVED}"${NC}
