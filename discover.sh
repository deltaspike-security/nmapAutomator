#!/bin/bash

if [ -z "$1" ]
then
        echo "Usage: ./discover.sh <IP>"
        exit 1
fi

printf "\n----- NMAP -----\n\n" > results

echo "Running Nmap..."
nmap -Pn $1 >> results

while read line
do
        if [[ $line == *open* ]] && [[ $line == *http* ]]
        then
                echo "Running Dirb..."
                dirb https://$1 > temp1

        	echo "Running WhatWeb..."
        	whatweb $1 -v > temp2
        fi
        
        if [[ $line == *open* ]] && [[ $line == *smb* ]]
        then
                echo "Running Smb Enum..."
                enum4linux -a $1 > temp3

        fi
        
done < results

if [ -e temp1 ]
then
        printf "\n----- DIRB -----\n\n" >> results
        cat temp1 >> results
        rm temp1
fi

if [ -e temp2 ]
then
    printf "\n----- WEB -----\n\n" >> results
        cat temp2 >> results
        rm temp2
fi

if [ -e temp3 ]
then
    printf "\n----- SMB -----\n\n" >> results
        cat temp3 >> results
        rm temp3
fi

cat results
