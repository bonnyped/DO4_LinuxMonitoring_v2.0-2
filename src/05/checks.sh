#!/bin/bash

. ./print.sh

if [[ $# -ne 1 ]]; then
    print
fi
if ! [[ $1 =~ ^[1234] ]]; then
    print
fi

mkdir result 2>/dev/null
