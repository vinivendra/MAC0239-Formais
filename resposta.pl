use warnings;
use strict;

# Tabuleiro
my @cell;


# Contadores
my $i;
my $j;
my $k;
my $l;
my $a;

my @answer;

my $base = 0;

# Leitura da entrada

$a = (<>);

for ($l = 0; $l < 729; $l ++) {
    if ($a =~ s/([-]?[\d]+)//) {
        $answer[$l] = $1;
    }
}

$l = 0;

print "┏━━━┯━━━┯━━━┳━━━┯━━━┯━━━┳━━━┯━━━┯━━━┓\n";

for ($i = 0; $i < 9; $i++) {
    for ($j = 0; $j < 9; $j++) {
        if ($j%3 == 0) { print "┃"; }
        else { print "│"; }
        for ($k = 0; $k < 9; $k++) {
            if ($answer[$l] > 0) {
                $answer[$l] = $answer[$l]%9;
                if ($answer[$l] == 0) { $answer[$l] = 9; }
                print " ".$answer[$l]." ";
            }
            
            $l ++;
        }

    }
    print "┃\n";
    if ($i != 8) {
        if ($i%3 != 2) { print "┠───┼───┼───╂───┼───┼───╂───┼───┼───┨\n"; }
        else { print "┣━━━┿━━━┿━━━╋━━━┿━━━┿━━━╋━━━┿━━━┿━━━┫\n"; }
    }
}
print "┗━━━┷━━━┷━━━┻━━━┷━━━┷━━━┻━━━┷━━━┷━━━┛\n";


