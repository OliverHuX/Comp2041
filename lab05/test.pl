#!/usr/bin/perl -w

use Cwd qw();
my $path = Cwd::cwd();


$base = mkdir (".snapshot.d");
print "$path\n","base is $base\n";
opendir(my $DIR, $source_dir) || die "can't opendir $source_dir: $!";  
my @files = readdir($DIR);
#my @files = <*>;
foreach my $file (@files) {
  print $file . "\n";
}
