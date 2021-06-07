#!/bin/sh

if test -e .shrug
then
    ./shrug-init > info
    match=`egrep 'shrug-init: error: .shrug already exists' "info"`
    if [ "$match" == "shrug-init: error: .shrug already exists" ]
    then
        echo "error check works well"
        rm info
    fi
else
    ./shrug-init > info
    match=`egrep 'Initialized empty shrug repository in .shrug' "info"`
    if [ "$match" == "Initialized empty shrug repository in .shrug" ]
    then
       if test -e .shrug
       then
        echo "initialising .shrug works well"
        rm info
        fi
    fi
fi