#!/bin/bash

PATTERN_TIME_STAMP="^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}$"

while [[ $var_start == "" ]]; do
    read -p 'Введите дату и время старта интервала (пример 2024-01-01 00:00): ' var_start
    if [[ ! $var_start =~ $PATTERN_TIME_STAMP ]]; then
        var_start=""
        echo -e "${RED}Неправильный формат даты и времени, обратите внимание на пример: ${GREEN}2024-01-01 00:00${NC}"
    else
        echo -e "Дата начала интервала принята: ${GREEN}${var_start}${NC}"
        SPECIFIED_DATE_START=$(date -d "$var_start" +"%s")
    fi
done

while [[ $var_end == "" ]]; do
    read -p 'Введите дату и время окончания интервала (пример 2024-01-01 00:00): ' var_end
    if [[ ! $var_end =~ $PATTERN_TIME_STAMP ]]; then
        var_end=""
        echo -e "${RED}Неправильный формат даты и времени, обратите внимание на пример: ${GREEN}2024-01-01 00:00${NC}"
    else
        echo -e "Дата окончания интервала принята: ${GREEN}${var_end}${NC}"
        SPECIFIED_DATE_END=$(date -d "$var_end" +"%s")
    fi
done
