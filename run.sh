#!/bin/bash

make clean
make

LIST=('ad01' 'ic' 'kws' 'vww')

for var in ${LIST[@]}
do
    isdiff=$(diff -q "./onnsim_output_$var.bin" "./precision_output_$var.bin")
    echo -e "\e[0;44m Compare $var \e[0m"
    if [ -n "$isdiff" ]
    then
        echo -e "\e[0;31m $var diff \e[0m"
    else
        echo -e "\e[0;32m PASS \e[0m"
    fi
done

make clean

