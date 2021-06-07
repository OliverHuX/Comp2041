#!/bin/sh
#Written by Xiao Hu
#z5223731

for image in $@
do
    time=`date|cut -d ' ' -f 2-4|sed 's/:[0-9][0-9]$//'`
    #echo $time

    convert -gravity south -pointsize 36 -draw "text 0,10 '$time'" "$image" temporary_$image

done
