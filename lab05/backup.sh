#!/bin/sh

for file in $@
do
    i=0
    while test -e ".$file.$i"
    do
        i=$((i + 1))
    done
    cp "$file" ".$file.$i"
    echo "Backup of '$file' saved as '.$file.$i'"
done
