#!/bin/sh

if [ ! -e .shrug ]
then
    ./shrug-commit "-m" "file" > info
    match=`egrep 'shrug-commit: error: no .shrug directory containing shrug repository exists' "info"`
    if [ "$match" == "shrug-commit: error: no .shrug directory containing shrug repository exists" ]
    then
        echo "no .shrug check works well"
        rm info
    fi
else
    index=".shrug/sub-directory"
    if [ ! -e ".shrug/sub-directory.0" ]
    then 
        ./shrug-commit "-m" "file" > info
        match=`egrep 'nothing to commit' "info"`
        if [ "$match" == "nothing to commit" ]
        then
            echo "no index check works well"
            rm info
        fi
    fi
    ./shrug-commit "file" > info
    match=`egrep "usage: shrug-commit \[\-a\] \-m commit-message" "info"`
    if [ "$match" == "usage: shrug-commit [-a] -m commit-message" ]
    then
        echo "argument check works well"
        rm info
    fi
fi