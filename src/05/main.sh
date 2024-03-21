#!/bin/bash

. ./checks.sh

cat ../04/*.log >> whole.log

if [[ $1 == 1 ]]; then
    awk -f "sorter.awk" whole.log >result/sorted_by_error_codes.log
elif [[ $1 == 2 ]]; then
    awk -f "uniqer.awk" whole.log >result/uniq_ip.log
    echo "Всего строк для поиска уникальных ip адресов: " $(cat whole.log | wc -l)
    echo "Всего строк с уникальным ip адресами: " $(cat result/uniq_ip.log | wc -l)
elif [[ $1 == 3 ]]; then
    awk -f "errcodes.awk" whole.log >result/just_4xx_and_5xx.log
elif [[ $1 == 4 ]]; then
    awk -f "errcodes.awk" whole.log >result/tmp.log
    echo "Всего строк для поиска уникальных только записей с кодами ошибок: " $(cat whole.log | wc -l)
    echo "Всего строк только с кодами ошибок: " $(cat result/tmp.log | wc -l)
    awk -f "uniqer.awk" result/tmp.log >result/uniq_ip_and_error_codes.log
    echo "Всего строк для поиска уникальных ip адресов, чьи строки содержат ошибки в кодах ответа: " $(cat result/tmp.log | wc -l)
    echo "Всего строк с уникальным ip адресами, чьи строки содержат ошибки в кодах ответа: " $(cat result/uniq_ip_and_error_codes.log | wc -l)
    rm -rf result/tmp.log
fi

rm -f whole.log 2>/dev/null
