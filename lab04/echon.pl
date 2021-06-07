#!/usr/bin/perl -w


if ($#ARGV != 1) {
    print "Usage: ./echon.pl <number of lines> <string>", "\n";
    exit 1;
}
if ($ARGV[0] !~ /^\d+$/) {
    print "./echon.pl: argument 1 must be a non-negative integer", "\n";
    exit 1;
} 

for ($n = $ARGV[0]; $n > 0; $n--) {
    print "$ARGV[1]", "\n";
}



