#!/bin/dash

i=0
while test -e ".snapshot.$i"
do
    i=$((i + 1))
done

mkdir ".snapshot.$i"

for file in *
do

#base="$PWD"

#file_dir="$PWD"

    cp -r "$PWD/$file" "$PWD/.snapshot.$i/"
    
done

echo "Creating snapshot $i"