#!/bin/sh

test_file='./shuffle.pl'

for i in 0 1 500 1000
do
   seq $i|sort > ordered0
   seq $i|"$test_file" > shuffled1
   cat shuffled1|sort > ordered1
   seq $i|"$test_file" > shuffled2

   if (! diff ordered0 ordered1 > /dev/null)
   then
      echo "You f**ked up the input"
      worked='false'
   fi

   if [ $i -ge 50 ] && (diff shuffled1 shuffled2 > /dev/null)
   then
      echo "Your shuffle isn't random"
      worked='false'
   fi
done

if $worked
then
   echo "Well done :)hhhhhhha"
fi

rm ordered* shuffled*