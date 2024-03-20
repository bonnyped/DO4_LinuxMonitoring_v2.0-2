#!/bin/bash

# check number of arguments
if [ $# -ne 3 ]; then
    echo -e "${RED}Необходимо ввести 3 параметра${NC}"
    exit
fi

#check that arg 1 contains just latin letters && their number is between 1 AND 7 symbols
if ! [[ $1 =~ ^[a-zA-Z]+$ ]]; then
    echo -e "${RED}Первый параметр должен быть символами a-z или A-Z${NC}"
    exit
elif [ ${#1} -gt 7 ]; then
    echo -e "${RED} Длина первого параметра должна от 1 до 7 символов${NC}"
    exit
fi

#check that arg 2 contains just latin letters && their number is between 1 AND 7 symbols && extentions number of symbols between 1 AND 3
if [[ "$2" =~ ^[a-zA-Z]+\.[a-zA-Z]+$ ]]; then
    FILE_NAME=$(echo $2 | cut -d'.' -f 1)
    FILE_EXTANTION=$(echo $2 | cut -d'.' -f 2)
else
    echo -e "${RED}Второй параметр буквы англиского якыка для имени от 1 до 7 символов, для расшиерения от 1 до 3${NC}"
    exit
fi
if [ ${#FILE_NAME} -gt 7 ]; then
    echo -e "${RED}Шаблон для имени файла. Введено более 7 символов${NC}"
    exit
elif [ ${#FILE_EXTANTION} -gt 3 ]; then
    echo -e "${RED}Шаблон для расширения файла. Введено более 3х сиволов${NC}"
    exit
fi

#check the custom file size, must be lawer than 100Mb
if ! [[ $3 =~ ^[0]+?[1-9][0-9]?+$ ]]; then
    echo -e "${RED}Третий параметр должен быть целым числом > 0 и <= 100 (измеряется в мегабайтах)${NC}"
    exit
elif [[ $3 =~ ([1-9][0-9]?+)$ ]]; then
    MATCH="${BASH_REMATCH[1]}"
fi
if [[ "${MATCH}" -gt 100 ]]; then
    echo -e "${RED}Третий параметр должен быть менее числа 101${NC}"
    exit
fi
