#!/usr/bin/perl -w

my @lines = <>;
my $function_flag = 0;
my $case_flag = 0;
foreach my $line (@lines) {
    #=================subset 0====================#
    #print new line
    my $common = "";
    if ($line =~ /^\n$/) {
        print "$line";
        next;
    } else {
    #delete the new line character of the line
        $line =~ s/\n//;
    }
    #skip do and then, print } when done or fi is reached in for loop
    if ($line =~ /( *)do$/ || $line =~ /( *)then$/) {
        if ($line !~ /\;/) {
            next;
        } else {
            $line =~ s/\; then//g;
            $line =~ s/\; do//g;
        }
    } elsif ($line =~ /( *)done$/ || $line =~ /( *)fi$/) {
        print "$1}", "\n";
        next;
    #print "} else {" when else is reached in if statement
    } elsif ($line =~ /( *)else$/) {
        print "$1} else {", "\n";
        next;
    }
    if ($line =~ /return 0/) {
        $line =~ s/return 0/return 1/;
    } elsif ($line =~ /return 1/) {
        $line =~ s/return 1/return 0/;
    }
    if ($line =~ /( *)case/) {
        $case_flag = 1;
        $line = "#" . $line;
        print "$line\n";
        next;
    }
    if ($line =~ /( *)esac$/) {
        $case_flag = 0;
        $line = "#" . $line;
        print "$line\n";
        next;
    }
    if ($line =~ /^( *);;$/) {
        next;
    }
    if ($case_flag == 1) {
        $line = "#" . $line;
        print "$line\n";
        next;
    }

    $line =~ s/\"\$\@\"/\@ARGV/g;
    $line =~ s/\"\$\#\"/\$\#ARGV/g;
    if ($line =~ /\$\((\w+)\)/) {
        my $command = $1;
        $line =~ s/\$\($command\)/\`$command\`/g;
    }
    if ($line =~ /^#!\/bin\/dash$/) {
        print "#!/usr/bin/perl -w", "\n";
    } elsif ($line =~ /^#.*/) {
        print $line, "\n";
    } elsif ($line =~ /( *)(.*)echo (.*)/) {
        my $str1 = $2;
        my $space = $1;
        my $str = $3;
        print "$space";
        if ($str1 =~ /&&/) {
            $str1 =~ s/&&/and/g;
            print "$str1";
        } elsif ($str1 =~/\|\|/) {
            $str1 =~ s/\|\|/or/g;
            print "$str1";
        }
        #deal with quotation marks for subset 2 and 3
        $str = quote_translate($str);
        #deal with "$" sign for subset 2
        if ($str =~ /\$([0-9]+)/) {
            my $num = $1 - 1;
            $str =~ s/\$$1//;
            print "print \"$str\$ARGV[$num]\\n\";", "\n";
        #deal with -n option in subset 3
        } elsif ($str =~ /\-n (.*)/) {
            $str = quote_translate($1);
            print "print \"$str\";", "\n";
        } elsif ($str =~ /`\w+`/) {
            print "print $str;", "\n";
        } else {
            print "print \"$str\\n\";", "\n";
        }
    } elsif ($line =~ /ls .*/) {
        print "system \"$line\";", "\n";
    } elsif ($line !~ /\s/ && $line !~ /=/ && $line !~ /\n/ && $line !~ /\}/) {
        print "system \"$line\";", "\n";
    } elsif ($line =~ /( *)\w+=/) {
        my $space = $1;
        if ($space) {
            $line =~ s/ +//;
        }
        if ($line =~ /\#/) {
            my @w = split "#", $line;
            $line = $w[0];
            $common = " #" . $w[1];
        }
        $line =~ s/ +$//;
        my @parts = split /=/, $line;
        my $var1 = $parts[0];
        my $var2 = $parts[1];
        
        if ($var2 =~ /^\$([0-9]+)$/) {
            my $num = $1 - 1;
            if ($function_flag == 1) {
                print "${space}\$$var1 = \$_[$num]$common;", "\n";
            } else {
                print "${space}\$$var1 = \$ARGV[$num]$common;", "\n";
            }
        } elsif ($var2 =~ /^\$\(\((.*)\)\)$/) {
            my $str = arithmetic_calculate($1);
            print "${space}\$$var1 = $str$common;", "\n";
        #expr builtin in subset 2
        } elsif ($var2 =~ /^`expr .*\w`.*/) {
            $var2 =~ s/`expr//;
            $var2 =~ s/`/;/;
            print "${space}\$$var1 = $var2$common", "\n";
        } elsif ($var2 =~ /^\$(.*)/) {
            print "${space}\$$var1 = \$$1$common;", "\n";
        } elsif ($var2 =~ /^\d+$/) {
            print "${space}\$$var1 = $var2$common;", "\n";
        } elsif ($var2 =~ /^"\w+"$/) {
            print "${space}\$$var1 = $var2$common;", "\n";
        } else {
            print "${space}\$$var1 = '$var2'$common;", "\n";
        }
    #==================subset 1====================#
    } elsif ($line =~ /( *)cd (.*)/) {
        my $space = $1;
        print "${space}chdir '$2';", "\n";
    } elsif ($line =~ /( *)for .*/) {
        my $space = $1;
        if ($space) {
            $line =~ s/ +//;
        }
        my $new_line = for_translate($line);
        print "${space}$new_line", "\n";
    } elsif ($line =~ /( *)exit .*/) {
        print "$line;", "\n";
    } elsif ($line =~ /( *)read (.*)/) {
        print "$1\$$2 = <STDIN>;", "\n", "$1chomp \$$2;", "\n";
    #==================subset 2====================#
    } elsif ($line =~ /( *)if .*/ || $line =~ /( *)elif .*/ || $line =~ /( *)while .*/) {
        my $space = $1;
        if ($space) {
            $line =~ s/ +//;
        }
        my $new_line = if_while_translate($line);
        print "${space}$new_line", "\n";
    } elsif ($line =~ /( *)test (.*)/) {
        my $space = $1;
        my $str = $2;
        if ($str =~ /^\$\(\((.*)\)\)(.*)/) {
            my $str1 = $2;
            my $str2 = arithmetic_calculate($1);
            $str1 =~ /.*(-\w+)(.*)/;
            my $str3 = $2;
            my $operator = arithmetic_symbol($1);
            $str3 =~ s/-\w/$operator/;
            $str3 =~ s/\&\&/and/;
            $str3 =~ s/\|\|/or/;
            print "${space}$str2 $operator $str3;\n";
        }
    #==================subset 3====================#
    } elsif ($line =~ /^\w+=(.*)/) {
        print "$1\n";
    #==================subset 4====================#
    } elsif ($line =~ /( *)local (.*)/) {
        my $space = $1;
        my $str = $2;
        my @arr;
        my @words = split /\s+/, $str;
        my $arr_words_size = $#words + 1;
        my $count = 1;
        push @arr, "my (";
        foreach my $word (@words) {
            if ($count == $arr_words_size) {
                push @arr, "\$$word)";
            } else {
                push @arr, "\$$word, "
            }
            $count++;
        }
        $str = join "", @arr;
        print "${space}$str;\n";
    #} elsif ($line =~ /return 0/) {
    #    $line =~ s/0/1/g;
    #    print "$line;\n";
    } elsif ($line =~ /^( *)return/) {
        print "$line;\n";
    } elsif ($line =~ /}$/) {
        $function_flag = 0;
        print "$line\n";
    } elsif ($line =~ /\(\)/) {
        $function_flag = 1;
        $line =~ s/\(\)//;
        $line = "sub " . $line;
        print "$line\n"
    } elsif ($line =~ /( *)mv/) {
        print "system \"$line\";", "\n";
    } elsif ($line =~ /( *)chmod (.*)/) {
        my $space = $1;
        my $str = chmod_translate($2);
        print "${space}$str\n";
    } elsif ($line =~ /( *)rm (.*)/) {
        my $space = $1;
        my $str = rm_translate($2);
        print "${space}$str\n";
    } elsif ($line =~ /&&/) {
        $line =~ s/&&/and/g;
        print "$line\n";
    } elsif ($line =~ /\|\|/) {
        $line =~ s/\|\|/or/g;
        print "$line\n";
    }
}

sub for_translate {
    my @words = split /\s+/, $_[0];
    my $arr_words_size = $#words + 1;
    my $glob_sign = 0;
    if ($arr_words_size == 4 && $words[3] =~ /\*.*/) {
        $glob_sign = 1;
    }

    my @arr;
    my $count = 1;
    foreach my $word (@words) {
        if ($count == 1) {
            push @arr, "foreach ";
            $count++;
            next;
        } elsif ($count == 2) {
            push @arr, "\$$word ";
            $count++;
            next;
        #skip "in" in for loop
        } elsif ($count == 3) {
            $count++;
            next;
        } elsif ($count == 4) {
            if ($glob_sign == 1) {
                push @arr, "(glob(\"$word\")) {";
                next;
            } else {
                push @arr, "(";
            }
        }
        if ($word =~ /^\d+$/) {
            push @arr, $word;
        } else {
            push @arr, "'$word'";
        }
        if ($count >= 4 && $count != $arr_words_size) {
            push @arr, ", ";
        } elsif ($count >= 4 && $count == $arr_words_size) {
            push @arr, ") {";
        }
        $count++;
    }
    return join "", @arr;
}

sub quote_translate {
    my $str = $_[0];
    my $len = length($str);
    if ($str =~ /^-n .*/) {
        return $str;
    }
    if ($str =~ /^('|").+/ && $str =~ /.('|")$/) {
        $str = substr $str, 1, ($len - 2);
    }
    $str =~ s/"/\\"/g;
    return $str;
}

sub if_while_translate {
    my @words = split /\s+/, $_[0];
    my $arr_words_size = $#words + 1;
    my @arr;
    my $count = 1;
    foreach my $word (@words) {
        if ($words[1] ne "test" && $words[1] ne "[") {
            if ($count == 2) {
                push @arr, "(! system \"$word ";
            } elsif ($count == $arr_words_size) {
                push @arr, "$word\") {";
            } else {
                push @arr, "$word ";
            }
        } elsif ($words[1] eq "test") {
            if ($word =~ /^if$/) {
                push @arr, "$word (";
            } elsif ($word =~ /^while$/) {
                push @arr, "$word (";
            } elsif ($word =~ /^elif$/) {
                push @arr, "} elsif (";
            } elsif ($word =~ /^test$/) {
                $count++;
                next;
            #virable name case like $var
            } elsif ($word =~ /^\$.*/) {
                push @arr, "$word";
            #file-based and number-based conditions like -d -r -eq - lt ect
            } elsif ($word =~ /^-\w+$/) {
                my $symbol = arithmetic_symbol($word);
                if ($symbol) {
                    push @arr, " $symbol ";
                } elsif ($word =~ /\-o/) {
                    push @arr, " || ";
                } elsif ($word =~ /\-a/) {
                    push @arr, " && ";
                } else {
                    push @arr, "$word ";
                }
            } elsif ($word =~ /^\d+$/) {
                push @arr, "$word";
            } elsif ($word !~ /^\d+/ && $word !~ /^=$/) {
                push @arr, "\'$word\'";
            } elsif ($word eq "=") {
                push @arr, " eq ";
            }
            if ($count == $arr_words_size) {
                push @arr, ") {";
            }
        } else {
            if ($word =~ /^if$/) {
                push @arr, "$word (";
            } elsif ($word =~ /^while$/) {
                push @arr, "$word (";
            } elsif ($word =~ /^elif$/) {
                push @arr, "} elsif (";
            #[] for subset 3
            } elsif ($word =~ /^\[+$/) {
                next;
            } elsif ($word =~ /^\]+$/) {
                push @arr, ") {";
            #virable name case like $var
            } elsif ($word =~ /^\$.*/) {
                push @arr, "$word";
            #file-based and number-based conditions like -d -r -eq - lt ect
            } elsif ($word =~ /^-\w+$/) {
                my $symbol = arithmetic_symbol($word);
                if ($symbol) {
                    push @arr, " $symbol ";
                } elsif ($word =~ /\-o/) {
                    push @arr, " || ";
                } elsif ($word =~ /\-a/) {
                    push @arr, " && ";
                } else {
                    push @arr, "$word ";
                }
            } elsif ($word =~ /^\d+$/) {
                push @arr, "$word";
            } elsif ($word =~ /^true$/) {
                push @arr, "1) {";
            } elsif ($word !~ /^\d+/ && $word !~ /^=$/) {
                push @arr, "\'$word\'";
            } elsif ($word eq "==" || $word eq "!=") {
                push @arr, " $word ";
            }
        }
        #-d / -r option
        #if [] need to be implemented
        $count++;
    }
    return join "", @arr;
}

#convert -eq/-ne/-gt/-ge/-lt/-le in ==/!=/>/>=/</<=
sub arithmetic_symbol {
    $symbol = $_[0];
    if ($symbol eq "-eq") {
        return "==";
    } elsif ($symbol eq "-ne") {
        return "!=";
    } elsif ($symbol eq "-gt") {
        return ">";
    } elsif ($symbol eq "-ge") {
        return ">=";
    } elsif ($symbol eq "-lt") {
        return "<";
    } elsif ($symbol eq "-le") {
        return "<=";
    }
}

#$(()) translate
sub arithmetic_calculate {
    my $exp = $_[0];
    my @words = split /\s/, $exp;
    my @arr;
    if ($#words == 0) {
        $exp =~ /(.*)(\w+)(.*)/;
        return "\$$1$2$3";
    }
    foreach my $word (@words) {
        #number is matched
        if ($word =~ /^\d+$/) {
            push @arr, $word;
        } elsif ($word =~ /^\w+$/) {
            push @arr, "\$$word";
        } else {
            push @arr, " $word ";
        }
    }
    return join "", @arr;
}

sub chmod_translate {
    my $str = $_[0];
    my @words = split /\s+/, $str;
    my $arr_words_size = $#words + 1;
    my $count = 1;
    my @arr;
    push @arr, "chmod ";
    foreach my $word (@words) {
        if ($word =~ /^\d+$/) {
            push @arr, "$word, ";
        } elsif ($count == $arr_words_size) {
            push @arr, "'$word';";
        } else {
            push @arr, "'$word', "
        }
        $count++;
    }
    return join "", @arr;
}

sub rm_translate {
    my $str = $_[0];
    my @words = split /\s+/, $str;
    my $arr_words_size = $#words + 1;
    my $count = 1;
    my @arr;
    push @arr, "unlink ";
    foreach my $word (@words) {
        if ($count == $arr_words_size) {
            push @arr, "'$word';";
        } else {
            push @arr, "'$word', "
        }
        $count++;
    }
    return join "", @arr;
}

#common the switch caz there is no switch in perl 5
#sub case_translate {
#    my $str = $_[0];
    #"apple") echo "Apple pie is quite tasty."
    #case 10           { print "number 100\n" }
#    $str =~ s/\)/\t{/;
#    $str =~ s/echo/print/;
#    $str =~ /^( *)/;
#    my $space = $1;
#    $str =~ s/^( *)//;
#    $str = "case " . $str;
#    $str = $space . $str;
#    $str =~ s/ +$//;
#    $str = $str . ", \"\\n\" }";
#    print $str;
#}
