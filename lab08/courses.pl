#!/usr/bin/perl -w

use LWP::Simple;
$code = $ARGV[0];
$url = "http://timetable.unsw.edu.au/current/$ARGV[0]KENS.html";
my $data = get $url or die;
my @courses = $data =~ /<td class.*><a href.*$code.*/g;
my %hash;
foreach my $line (@courses) {
    $line =~ s/^ *//;
    if ($line =~ m/<td class.*><a href.*$code.*>$code[0-9]{4}.*/g) {     
        next;
    }
    $line =~ s/<td class="data"><a href="//;
    $line =~ s/.html">/ /;
    $line =~ s/<.*>$//;
    $hash{$line}++;
}

foreach my $course (sort keys %hash) {
    print "$course\n";
}
