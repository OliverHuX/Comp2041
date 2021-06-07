#!/bin/sh
#Written by Xiao Hu
#z5223731

for image in $@
do
    display "$image"

    echo "Address to e-mail this image to?"
    read address

    if [ -n "$address" ]
    then
        echo "Message to accompany image?"
        read message

        echo "$message"|mutt -s 'check it out' -e 'set copy=no' -a "$image" -- "$address"

    fi

done
