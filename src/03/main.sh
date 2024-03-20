#!/bin/bash

RED='\033[0;31m'
GREEN='\033[92m'
BLUE='\033[94m'
NC='\033[0m'
FILES_REMOVED=0

. ./part3_checks.sh

case $1 in
    1) . ./part3_remove_via_log.sh;;
    2) . ./part3_remove_via_time_interval.sh;;
    3) . ./part3_remove_via_name_mask.sh;;
esac