#!/usr/bin/perl -w

my %art_key_word_hash;
my %art_word_hash;

foreach my $file(glob "lyrics/*.txt"){

    open my $f, '<', "$file" or die "./frequency.pl: can't open $file\n";
    my @arr;
    $file =~ s/.*\///g;
    $file =~ s/.txt//g;
    $file =~ s/_/ /g;

    while ($line = <$f>) {
        @arr = map { lc } $line =~ /[a-zA-Z]+/g;
        foreach my $word(@arr) {
            $art_key_word_hash{$file}{$word}++;
            $art_word_hash{$file}++;
        }
    }

    close $f;
}	

foreach my $file(@ARGV){

    my %log_prob;	
    open my $f, '<', "$file" or die "./frequency.pl: can't open $file\n";
    while ($line = <$f>) {
        my @arr = map { lc } $line =~ /[a-zA-Z]+/g;
        foreach my $word(@arr) {
            foreach my $artist(keys %art_word_hash){
                no warnings 'all';
                my $numerator = $art_key_word_hash{$artist}{$word} + 1;
                my $denominator = $art_word_hash{$artist};
                my $value = $numerator/$denominator;
                $log_prob{$artist}+=log($value);
            }
        }
    }
    my @artistvalues = sort {$log_prob{$b} <=> $log_prob{$a} } keys %log_prob;
    printf "%s most resembles the work of %s (log-probability=%.1f)\n", $file, $artistvalues[0], $log_prob{$artistvalues[0]};
    close $f;
}