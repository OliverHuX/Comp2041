#!/usr/bin/perl -w

@array=();
$i = 0;
$j = 0;
while ($line = <STDIN>) {
    $array[$i] = $line;
    $i++;
}

while ($j < $i) {
    $random_num = rand($i);
    if (defined($array[$random_num])) {
        print $array[$random_num];
        undef($array[$random_num]);
        $j++;
    }
}