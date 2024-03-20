#!/bin/bash

ZERO=0
START_IN_SECONDS=$ZERO

function calculate_time {
    if [[ $START_IN_SECONDS -eq 0 ]]; then
        START_IN_SECONDS=$(date +%s)
        START_TIME="$(date +%H):$(date +%M):$(date +%S)"
    else
        END_IN_SECONDS=$(date +%s)
        EXECUTE_IN_SECONDS=$(($END_IN_SECONDS - $START_IN_SECONDS))
        HOURS=$(($EXECUTE_IN_SECONDS / 3600))
        ((EXECUTE_IN_SECONDS -= $HOURS * 3600))
        MINUTES=$(($EXECUTE_IN_SECONDS / 60))
        ((EXECUTE_IN_SECONDS -= $MINUTES * 60))
        echo -e ${BLUE}"Script started: ${START_TIME}" | tee -a ${LOG_PLACEMENT}file.log
        END_TIME="$(date +%H):$(date +%M):$(date +%S)"
        echo "Script ended: ${END_TIME}" | tee -a ${LOG_PLACEMENT}file.log
        printf 'Script execute time: %.2d:%.2d:%.2d' ${HOURS} ${MINUTES} ${EXECUTE_IN_SECONDS} | tee -a ${LOG_PLACEMENT}file.log
        echo -e "${NC}"
    fi
}

function generate_name {
    SYMBOLS_FROM_ARG=${1,,}

    case ${#SYMBOLS_FROM_ARG} in
    1) MIN_REPEATE_OF_SYMBOL=5 ;;
    2) MIN_REPEATE_OF_SYMBOL=3 ;;
    3) MIN_REPEATE_OF_SYMBOL=2 ;;
    4) MIN_REPEATE_OF_SYMBOL=2 ;;
    *) MIN_REPEATE_OF_SYMBOL=1 ;;
    esac

    MAX_REPEATE_OF_SYMBOL=$((240 / ${#SYMBOLS_FROM_ARG}))

    ENTITY_NAME=
    for ((fnindex = 0; $fnindex < ${#SYMBOLS_FROM_ARG}; ++fnindex)); do
        NUMBER_OF_CURRENT_SYMBOL=$(("$MIN_REPEATE_OF_SYMBOL" + "$RANDOM" % "$MAX_REPEATE_OF_SYMBOL"))
        for ((rindex = 0; rindex < "$NUMBER_OF_CURRENT_SYMBOL"; ++rindex)); do
            ENTITY_NAME+=${SYMBOLS_FROM_ARG:$fnindex:1}
        done
    done
}

function create_subfolder {
    while [[ "$AVAILABLE_FREE_SPACE" -gt 0 ]]; do
        PATH_TO_CREATE_FOLDER=$(sudo find / -mount ! -wholename '\/usr\/bin*' ! -wholename '\/usr\/sbin*' -type d -perm /u=w | shuf -n 1)
        SUBFOLDERS_NUMBER=$(echo $((1 + $RANDOM % 100)))
        for ((sindex = 0; sindex < $SUBFOLDERS_NUMBER; ++sindex)); do
            generate_name $FOLDER_NAME_SET
            ENTITY_NAME+="_$(date -d 'today' +%d%m%y)"
            if [[ $(sudo find ${PATH_TO_CREATE_FOLDER} -maxdepth 1 -name $ENTITY_NAME | wc -l) -eq 0 ]]; then
                CURRENT_FOLDER="${PATH_TO_CREATE_FOLDER}/${ENTITY_NAME}"
                sudo mkdir "$CURRENT_FOLDER"
                ((++FOLDERS_GENERATED))
                FOLDER_SIZE=$(sudo du --max-depth=0 ${CURRENT_FOLDER}/ | awk '{printf $1}')
                echo "${CURRENT_FOLDER}/ $(date -d 'today' +%d).$(date -d 'today' +%m).$(date -d 'today' +%y) $(sudo du -h --max-depth=0 ${CURRENT_FOLDER}/ | awk '{printf $1}')" >>${LOG_PLACEMENT}file.log
                AVAILABLE_FREE_SPACE=$(($AVAILABLE_FREE_SPACE - $FOLDER_SIZE))
                create_subfolders_files
            fi
        done
    done
}

function create_subfolders_files {
    FILES_IN_SUBFOLDER=$((1 + "$RANDOM" % 100))
    for ((fisindex = 0; fisindex < $FILES_IN_SUBFOLDER; ++fisindex)); do
        generate_name $FILE_NAME_SET
        ENTITY_NAME+="_$(date -d 'today' +%d%m%y)"
        ENTITY_NAME+=".$(shuf -e "${EXTANTION_SET:0:1}" "${EXTANTION_SET:1:1}" "${EXTANTION_SET:2:1}" | tr -d '\n')"
        FULL_FILE_NAME="$CURRENT_FOLDER/$ENTITY_NAME"
        sudo fallocate -l "${FILE_SIZE}mib" "$FULL_FILE_NAME"
        ((++FILES_GENERATED))
        echo "$FULL_FILE_NAME $(date -d 'today' +%d).$(date -d 'today' +%m).$(date -d 'today' +%y) $(sudo du -h --max-depth=0 ${FULL_FILE_NAME} | awk '{printf $1}')" >>${LOG_PLACEMENT}file.log
        FILE_SIZE_KB=$(sudo du $FULL_FILE_NAME | awk '{printf $1}')
        ((AVAILABLE_FREE_SPACE -= $FILE_SIZE_KB))
        if [[ $AVAILABLE_FREE_SPACE -lt 0 ]]; then
            echo -e "${RED}There is lower than 1Gb space left on device: 0$(echo "scale=3; ($AVAILABLE_FREE_SPACE + 1048576) /1048576" | bc ) Gb${NC}"

            fisindex=$FILES_IN_SUBFOLDER
            sindex=$SUBFOLDERS_NUMBER
            break
        fi
    done
}
