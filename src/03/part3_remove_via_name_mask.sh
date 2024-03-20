#!/ban/bash

echo -e ${RED}"Состояние памяти до удаления: $(df -h | awk '$6=="/"{print $4}')"

echo -e "${GREEN}Файлов и папок удалено: $(sudo find $(sudo find / -mount -type d -regex "^.*[a-z]+_[0-9]+.$") | wc -l). Так же удалён file.log${NC}"

sudo rm -rf $(sudo find / -mount -type d -regex "^.*[a-z]+_[0-9]+.$") ../02/file.log 2> /dev/null

echo -e ${GREEN}"Состояние памяти после удаления: $(df -h | awk '$6=="/"{print $4}')${NC}"