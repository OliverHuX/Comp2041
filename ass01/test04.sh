#!/bin/sh

if [ ! -e .shrug ]
then
    ./shrug-status > info
    match=`egrep 'shrug-log: error: no .shrug directory containing shrug repository exists' "info"`
    if [ "$match" == "shrug-log: error: no .shrug directory containing shrug repository exists" ]
    then
        echo "no .shrug check works well"
        rm info
    fi
else
    repo=`ls .shrug|egrep "^[0-9]+"|sort|tail -n 1`
    if [ "$repo" = "" ]
    then
        ./shrug-status > info
        match=`egrep 'shrug-status: error: your repository does not have any commits yet' "info"`
        if [ "$match" == "shrug-status: error: your repository does not have any commits yet" ]
        then
            echo "no commit check works well"
            rm info
        fi
    fi
fi