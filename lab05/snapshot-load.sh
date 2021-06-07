#!/bin/dash

./snapshot-save.sh

for file in $PWD/.snapshot.$1/*.txt
do

#base="$PWD"
#file_dir="$PWD"
    #echo "$file"
    cp -r "$file" "$PWD/" 
    
done

echo "Restoring snapshot $1"
#num_file=`ls -l ".snapshot.$1/.*"|wc -l`

#for backup in ".snapshot.$1/.*"
#do
#    cp "$backup" 'cut -d '/' -f 2'
#done
#    echo "Creating snapshot $num_file"
#    echo "Restoring snapshot $1"