#!/bin/bash

. ./part2_functions.sh
. ./part2_checks.sh

RED='\033[0;31m'
GREEN='\033[92m'
BLUE='\033[94m'
NC='\033[0m'
LOG_PLACEMENT="./"
AVAILABLE_FREE_SPACE=$(($(df --output=avail / | tail -1) - 1048576))
FOLDER_SIZE=0
FOLDER_NAME_SET="$1"
FILE_NAME_SET=$(echo $2 | awk -F '.' '{printf $1}')
EXTANTION_SET=$(echo $2 | awk -F '.' '{printf $2}')
FILE_SIZE=$3
FOLDERS_GENERATED=0
FILES_GENERATED=0


calculate_time
create_subfolder

echo -e "${GREEN}Folders generated: ${FOLDERS_GENERATED}"
echo -e "Files generated: ${FILES_GENERATED}${NC}"

calculate_time
