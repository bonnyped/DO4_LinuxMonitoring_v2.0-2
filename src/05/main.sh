#!/bin/bash

. ./checks.sh

if [[ $1 == 1 ]]; then
    awk -f "sorter.awk" ../04/*.log >result/1.log
elif [[ $1 == 2 ]]; then
    awk -f "uniqer.awk" ../04/*.log >result/2.log
elif [[ $1 == 3 ]]; then
    awk -f "errcodes.awk" ../04/*.log >result/3.log
elif [[ $1 == 4 ]]; then
    awk -f "errcodes.awk" ../04/*.log >result/tmp.log
    awk -f "uniqer.awk" result/tmp.log >result/4.log
    rm -rf result/tmp.log
fi
