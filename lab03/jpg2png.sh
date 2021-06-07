#!/bin/sh
#Written by Xiao Hu
#z5223731

for file in *
do
    if echo "$file"|egrep -vq '\.jpg$|\.png$'
    then
        continue
    fi
    tmp_file=`echo "$file"|sed s/\.jpg//g|sed s/\.png//g`
    if test -e "$tmp_file.png"
    then
        echo "$tmp_file.png already exists"
        exit 1
    else
        convert "$tmp_file.jpg" "$tmp_file.png"
        rm "$tmp_file.jpg"
    fi
done

