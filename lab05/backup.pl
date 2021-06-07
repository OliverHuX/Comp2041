#!/usr/bin/perl -w
use File::Copy

$i = 0;
while (-e ".$ARGV[0].$i") {
    $i++;
}

copy("$ARGV[0]",".$ARGV[0].$i");
print "Backup of '$ARGV[0]' saved as '.$ARGV[0].$i'", "\n";