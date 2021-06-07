#!/usr/bin/perl -w

$target = lc($ARGV[0]);

foreach $file (glob "lyrics/*.txt") {
    open my $f, "<", $file or die;
    my @arr;
    my @word_arr;
    my $count = 0;
    my $word_count = 0;
    while ($line = <$f>) {
        @arr = map { lc } $line =~ /[a-zA-Z]+/g;
        @word_arr = grep(/^$target$/g, @arr);
        $count += $#arr;
        $count++;
        $word_count += $#word_arr;
        $word_count++;
    }
    
    $file =~ s/.*\///g;
    $file =~ s/.txt//g;
    $file =~ s/_/ /g;

    printf "%4d/%6d = %.9f %s\n", $word_count, $count, $word_count/$count, $file;
    close $f;
}