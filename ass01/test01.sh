#!/bin/sh

if [ ! -e .shrug ]
then
    ./shrug-add "file" > info
    match=`egrep 'shrug-add: error: no .shrug directory containing shrug repository exists' "info"`
    if [ "$match" = "shrug-add: error: no .shrug directory containing shrug repository exists" ]
    then
        echo "error check works well"
        rm info
        exit 0
    fi
else
    ./shrug-add > info
    match=`egrep 'usage: shrug-add <filenames>' "info"`
    if [ "$match" = "usage: shrug-add <filenames>" ]
    then
        echo "no argument check works well"
        rm info
    fi
    echo a > a
    ./shrug-add a
    index=`ls .shrug|egrep "sub-directory.[0-9]+"|sort|tail -n 1`
    if test -e .shrug/"$index"/a
    then
        echo "add works well"
    fi
fi