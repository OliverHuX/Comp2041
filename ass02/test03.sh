#!/bin/dash
# l [file|directories...] - list files
# written by andrewt@cse.unsw.edu.au as a COMP2041 example

ls -las "$@"
exit 0

#!/bin/dash
# print a contiguous integer sequence
start=$1
finish=$2

number=$start
while test $number -le $finish
do
    echo $number
    number=`expr $number + 1`  # increment number
done
