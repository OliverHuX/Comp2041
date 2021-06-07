#!/usr/bin/perl -w

use File::Copy;
use Cwd;

my $path = getcwd();

$i = 0;
while (-e ".snapshot.$i") {
    $i++;
}

$base = ".snapshot.$i";
mkdir ($base);

sub backup {
    my @files = <*>;
    foreach my $file (@files) {
        copy("$path/$file","$path/$base");
    }
    print "Creating snapshot $i", "\n";
}

if ("$ARGV[0]" eq "save") {
    backup();
} elsif ("$ARGV[0]" eq "load") {
    backup();
    my @backupfiles = <".snapshot.$ARGV[1]/*">;
    foreach my $backupfile (@backupfiles) {
        copy ("$backupfile", "$path");
    }
    print "Restoring snapshot $ARGV[1]", "\n";
}