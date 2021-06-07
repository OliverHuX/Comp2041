#!/usr/bin/perl -w

@files = ();
$num = 10;

foreach $arg (@ARGV) {
    if ($arg eq "--version") {
        print "$0: version 0.1\n";
        exit 0;
    } elsif ($arg =~ /^-\d+$/) {
        $arg =~ s/-//;
        $num = $arg
    } else {
        push @files, $arg;
    }
}

if ($#files == -1) {
    @lines = <STDIN>;
    $counter = $#lines + 1;
    if ($counter > $num) {
        for ($n = $counter - $num; $n < $counter; $n++){
            print "$lines[$n]";
        }
    } else {
        #s/' '//g for @lines;
        print @lines;
    }

}

foreach $file (@files) {
    open F, '<', $file or die "$0: Can't open $file: $!\n";

    if ($#files != 0) {
        print "==> $file <==", "\n";
    }
    @lines = <F>;

    $counter = $#lines + 1;
    if ($counter > $num) {
        for ($n = $counter - $num; $n < $counter; $n++){
            print "$lines[$n]";
        }
    } else {
        print @lines;
    }

    close F;
}