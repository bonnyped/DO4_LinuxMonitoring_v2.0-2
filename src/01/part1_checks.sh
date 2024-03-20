#!/bin/bash

ABS_PATH="$1"
# check number of arguments
if [ $# -ne 6 ]; then
    echo -e "${RED}Нужно ввести 6 параметров:"
    echo -e "1 - абсолютный валидный путь"
    echo -e "2 - целое число (количество подпапок)"
    echo -e "3 - список букв английского алфавита, используемых в названиях папок (не более 7 символов)"
    echo -e "4 - количество файлов создаваемых в каждой папке"
    echo -e "5 - список букв английского алфавита, используемых в названиях файлов (не более 7 символов для имени и 3х символов для расширения)"
    echo -e "6 - размер файлов в килобайтах (от 1 до 100)${NC}"
    exit
fi

#check that the path is the absolute path
if [[ $1 != /* ]]; then
    echo -e "${RED}Первый параметр - абсолтный путь${NC}"
    exit
fi

if [[ "${ABS_PATH: -1}" != / ]]; then
    ABS_PATH="$ABS_PATH/"
fi

if [[ $(find "${ABS_PATH}" -maxdepth 1 -type d 2>/dev/null | wc -l) -eq 0 ]]; then
    echo -e "${RED}Такой папки не существует, укажите верный путь к существующей папке!${NC}"
    exit
fi

#check that arg 2 is an integer, it iss the number of folders
if ! [[ "$2" =~ ^[0]+?[1-9][0-9]?+$ ]]; then
    echo -e "${RED}Второй параметр должен быть целым числом > 0 и <= 100${NC}"
    exit
fi

#check that arg contains just latin letters && their number is between 1 AND 7 symbols
if ! [[ "$3" =~ ^[a-zA-Z]+$ ]]; then
    echo -e "${RED}Третий параметр должен быть символами a-z или A-Z (максимум 7 символов)${NC}"
    exit
elif [ ${#3} -gt 7 ]; then
    echo -e "${RED}Введено более 7 символов${NC}"
    exit
fi

#check that arg 4 is an integer, it is the number of files
if ! [[ "$4" =~ ^[0]+?[1-9][0-9]?+$ ]]; then
    echo -e "${RED}Четвертый параметр должен быть целым числом > 0${NC}"
    exit
fi

#check that arg 5 contains just latin letters && their number is between 1 AND 7 symbols && extentions number of symbols between 1 AND 3
if [[ "$5" =~ ^[a-zA-Z]+\.[a-zA-Z]+$ ]]; then
    FILE_NAME=$(echo $5 | cut -d'.' -f 1)
    FILE_EXTANTION=$(echo $5 | cut -d'.' -f 2)
else
    echo -e "${RED}Пятый параметр буквы англиского якыка для имени от 1 до 7 символов, для расшиерения от 1 до 3${NC}"
    exit
fi
if [ ${#FILE_NAME} -gt 7 ]; then
    echo -e "${RED}Шаблон для имени файла. Введено более 7 символов${NC}"
    exit
elif [ ${#FILE_EXTANTION} -gt 3 ]; then
    echo -e "${RED}Шаблон для расширения файла. Введено более 3х сиволов${NC}"
    exit
fi

#check the custom file size, must be lawer than 100
if ! [[ "$6" =~ ^[0]+?[1-9][0-9]?+$ ]]; then
    echo -e "${RED}Шестой параметр должен быть целым числом > 0 и <= 100${NC}"
    exit
elif [[ $6 =~ ([1-9][0-9]?+)$ ]]; then
    MATCH="${BASH_REMATCH[1]}"
fi
if [[ "${MATCH}" -gt 100 ]]; then
    echo -e "${RED}Шестой параметр должен быть менее числа 101${NC}"
    exit
fi
