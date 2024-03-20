#!/bin/bash

# НЕ ЗАБЫТЬ ИЗМЕНИТЬ ЗАПИСЬ В ФАЙЛ, НУЖНО ДОБАВИТЬ ДАТУ СОЗДАНИЯ, СОГЛАСНО ТАСКУ

START_SCRIPT=$(date +%s)
RED='\033[0;31m'
GREEN='\033[92m'
BLUE='\033[94m'
NC='\033[0m'
TRY_TO_DOUBLE_GENARATE_FILE=0
SCRIPT_PLACEMENT="$(pwd)/"
AVAILABLE_FREE_SPACE=$(($(df --output=avail / | tail -1) - 1048576))

if [[ "$AVAILABLE_FREE_SPACE" -lt 0 ]]; then
echo -e "${RED}There is lower then 1GB space in partition \"/\", the end of the script.${NC}"
exit
fi

. ./part1_checks.sh
. ./part1_functions.sh

SKIP=0
FILES_GENERATED=0

PATH_WITH_END_SLASH="$1"
if [[ ${PATH_WITH_END_SLASH: -1} != "/" ]]; then
    PATH_WITH_END_SLASH="${PATH_WITH_END_SLASH}/"
fi

generate_folder_name "$2" "$3"
MASTER_FOLDER=$(head -n 1 ${SCRIPT_PLACEMENT}file_generator.log | awk '{printf $1}')
generate_name_file "$MASTER_FOLDER" "$4" "$5" "$6"
MASTER_FOLDER_SIZE="$(du -xs "$(echo "$MASTER_FOLDER" | awk '{printf $1}')" | awk '{printf $1}')"
while IFS= read -r folder; do
    if [[ "$STOP_SCRIPT" -ne 1 ]]; then
        if [[ "$SKIP" -eq 0 ]]; then
            SKIP=1
        else
            folder="$(echo "$folder" | cut -d " " -f1)"
            copy_master_folder_content "$MASTER_FOLDER" "$4" "$5" "$6" "$folder" "$MASTER_FOLDER_SIZE"
        fi
    fi
done <${SCRIPT_PLACEMENT}file_generator.log
echo -e "${GREEN}Number of created folders: ${FOLDERS_GENARATED}"
echo -e "${RED}Number of duplicates names of folders: ${TRY_TO_DOUBLE_GENARATE_FOLDER}"
echo -e "${GREEN}Number of created files: ${FILES_GENERATED}"
echo -e "${RED}Number of duplicates names of files: ${TRY_TO_DOUBLE_GENARATE_FILE}"
cd ..
if [[ $(find ${SCRIPT_PLACEMENT} -type f -wholename "${SCRIPT_PLACEMENT}create_file.log" | wc -l) -eq 1 ]]; then
    cat ${SCRIPT_PLACEMENT}create_file.log >>${SCRIPT_PLACEMENT}file_generator.log
    rm ${SCRIPT_PLACEMENT}create_file.log
fi

END_SCRIPT=$(date +%s)
calculate_script_execution_time
echo -e "${BLUE}Execution time of script $SCRIPT_EXECUTION_TIME_MIN minutes $SCRIPT_EXECUTION_TIME_SEC seconds${NC}"
