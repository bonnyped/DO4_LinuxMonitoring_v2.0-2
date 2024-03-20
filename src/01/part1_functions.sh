#!/bin/bash

function calculate_script_execution_time {
    SCRIPT_EXECUTION_TIME_SEC=$(("$END_SCRIPT" - "$START_SCRIPT"))
    SCRIPT_EXECUTION_TIME_MIN=0
    if [[ "$SCRIPT_EXECUTION_TIME_SEC" -gt 60 ]]; then
        SCRIPT_EXECUTION_TIME_MIN=$(("$SCRIPT_EXECUTION_TIME_SEC" / 60))
        SCRIPT_EXECUTION_TIME_SEC=$(("$SCRIPT_EXECUTION_TIME_SEC" - "$SCRIPT_EXECUTION_TIME_MIN" * 60))
    fi
}

function generate_prename {
    SYMBOLS_FROM_ARG=${1,,}
    NUMBER_OF_ALL_SYMBOLS=(0 0 0 0 0 0 0)
    ENTITY_NAME=

    case ${#SYMBOLS_FROM_ARG} in
    1) MIN_REPEATE_OF_SYMBOL=4 ;;
    2) MIN_REPEATE_OF_SYMBOL=2 ;;
    3) MIN_REPEATE_OF_SYMBOL=2 ;;
    *) MIN_REPEATE_OF_SYMBOL=1 ;;
    esac

    MAX_NUMBER_OF_SYMBOL=$((240 / ${#SYMBOLS_FROM_ARG}))

    for ((index = 0; index < ${#SYMBOLS_FROM_ARG}; ++index)); do
        NUMBER_OF_ALL_SYMBOLS["$index"]=$(("$MIN_REPEATE_OF_SYMBOL" + "$RANDOM" % "$MAX_NUMBER_OF_SYMBOL"))
    done

    for ((index = 0; index < "${#SYMBOLS_FROM_ARG}"; ++index)); do
        if [[ "${NUMBER_OF_ALL_SYMBOLS[$index]}" -eq 0 ]]; then
            break
        fi
        for ((jindex = 0; jindex < "${NUMBER_OF_ALL_SYMBOLS[$index]}"; ++jindex)); do
            ENTITY_NAME+="${SYMBOLS_FROM_ARG:$index:1}"
        done
    done
    ENTITY_NAME+="_$(date -d 'today' +%d%m%y)"
}

function check_double_name_next_create {
    return "$(find "$PATH_WITH_END_SLASH" -type d -name "$1" | wc -l)"
}

function determinate_max_number_of_folders {
    if [[ ${#1} -eq 1 ]]; then
        if [[ "$NUMBER_OF_NEEDS_FOLDERS" -gt 240 ]]; then
            NUMBER_OF_NEEDS_FOLDERS=240
            echo -e "${RED}Number of create folders was reduced because of max length of file name in OS (255) minus the task min legth name (4), minus digits for \"_\" (1) and curre date (6) in this way \n${GREEN}max number of folders to create is 240${NC}"
        fi
    elif [[ ${#1} -eq 2 ]]; then
        if [[ "$NUMBER_OF_NEEDS_FOLDERS" -gt 2000 ]]; then
            NUMBER_OF_NEEDS_FOLDERS=2000
            echo -e "${RED}The number of folders to be created was limited at around 2000 due to the length of time the script takes to create folders, if you want to create more folders, please add more letters to the character pattern to create a folder name.${NC}"
        fi
    elif [[ ${#1} -eq 3 ]]; then
        if [[ "$NUMBER_OF_NEEDS_FOLDERS" -gt 10000 ]]; then
            NUMBER_OF_NEEDS_FOLDERS=10000
            echo -e "${RED}The number of folders to be created was limited at around 10000 due to the length of time the script takes to create folders, if you want to create more folders, please add more letters to the character pattern to create a folder name.${NC}"
        fi
    fi
}

# generate folder name
function generate_folder_name {
    rm -rf ${SCRIPT_PLACEMENT}file_generator.log
    FOLDERS_GENARATED=0
    TRY_TO_DOUBLE_GENARATE_FOLDER=0
    NUMBER_OF_NEEDS_FOLDERS=$(echo "$1" | awk '$0*=1')
    PATTERN_TO_NAME_FOLDER="$2"
    determinate_max_number_of_folders "$PATTERN_TO_NAME_FOLDER"
    for ((gen_index = 0; gen_index < "$NUMBER_OF_NEEDS_FOLDERS"; ++gen_index)); do
        generate_prename "$PATTERN_TO_NAME_FOLDER"
        check_double_name_next_create "$ENTITY_NAME"
        if [[ "$?" -eq 0 ]]; then
            create_folder "$PATH_WITH_END_SLASH" "$ENTITY_NAME"
            ((++FOLDERS_GENARATED))
        else
            ((--gen_index))
            ((++TRY_TO_DOUBLE_GENARATE_FOLDER))
        fi
        if [[ $(("$FOLDERS_GENARATED" - "$TRY_TO_DOUBLE_GENARATE_FOLDER")) -eq -1200 ]]; then
            echo -e "${RED}It is not possible to create folders in an acceptable time, please change your request and try again!${NC}"
            break
        fi
    done
}

function create_folder {
    FULL_NAME="${1}${2}"
    mkdir "$FULL_NAME"
    FOLDER_SIZE=$(du -sh "$FULL_NAME" | cut -f1)
    echo "${FULL_NAME}/" "$FOLDER_SIZE" >>${SCRIPT_PLACEMENT}file_generator.log
}

function generate_name_file {
    NUMBER_OF_FILES=$(echo "$2" | awk '$0*=1')
    FILE_SIZE=$(echo "$4" | awk '$0*=1')
    PATTERN_TO_NAME_FILE=$(echo "$3" | cut -d. -f 1)
    PATTERN_TO_FILE_EXTANTION=$(echo "$3" | cut -d. -f 2)
    create_file "$1"
}

function create_file {
    for ((findex = 0; findex < "$NUMBER_OF_FILES"; ++findex)); do
        STOP_SCRIPT=0
        generate_prename "$PATTERN_TO_NAME_FILE"
        FILE_NAME="${ENTITY_NAME}."
        FILE_NAME+=$(shuf -e "${PATTERN_TO_FILE_EXTANTION:0:1}" "${PATTERN_TO_FILE_EXTANTION:1:1}" "${PATTERN_TO_FILE_EXTANTION:2:1}" | tr -d '\n')
        FOLDER_PATH=$(echo "$1" | awk '{ printf $1 }')
        check_space "$FILE_SIZE"
        if [[ "$STOP_SCRIPT" -eq 1 ]]; then
            echo -e ""$RED"Free space in \"/\" partition lower than 1GB${NC}"
            break
        else
            if [[ "$(find "$FOLDER_PATH" -name "$FILE_NAME" | wc -l)" -eq 0 ]]; then
                cd "$FOLDER_PATH" && fallocate -l "${FILE_SIZE}K" "${FILE_NAME}"
                echo "$FOLDER_PATH""${FILE_NAME} ""${FILE_SIZE}K " >>${SCRIPT_PLACEMENT}create_file.log
                ((++FILES_GENERATED))
            else
                ((--findex))
                ((++TRY_TO_DOUBLE_GENARATE_FILE))
            fi
        fi
    done
}

function check_space {
    if [[ $(("$AVAILABLE_FREE_SPACE" - "$1")) -lt 0 ]]; then
        findex="$NUMBER_OF_FILES"
        STOP_SCRIPT=1
    else
        AVAILABLE_FREE_SPACE=$(("$AVAILABLE_FREE_SPACE" - "$1"))
    fi
}

function copy_master_folder_content {
    SRC_FOLDER="$5"
    check_space $6
    if [[ "$STOP_SCRIPT" -ne 1 ]]; then
        cp "$MASTER_FOLDER"/* "$SRC_FOLDER"/
        find "${MASTER_FOLDER}" -type f -exec ls -lh {} \; | awk '{printf $9 " " $5 "\n" }' >>${SCRIPT_PLACEMENT}create_file.log
        ((FILES_GENERATED += $(echo "$2" | awk '$0*=1')))
    else
        generate_name_file "$SRC_FOLDER" "$2" "$3" "$4"
    fi
}
