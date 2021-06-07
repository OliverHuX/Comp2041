#!/usr/bin/perl -w

my @arr;
my $count = 0;
while ($line = <STDIN>) {
    @arr = $line =~ /[a-zA-Z]+/g;
    $count += $#arr;
    $count++;
}

print "$count words\n";