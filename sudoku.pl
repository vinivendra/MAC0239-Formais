
use warnings;
use strict;

# Tabuleiro
my @sudoku = ([], [], [], [], [], [], [], [], []);

# Contadores
my $i;
my $j;

# Leitura da entrada
my $a = (<>);

for ($i = 0; $i < 9; $i++) {
    
    for ($j = 0; $j < 9; $j++) {
        
        if ($a =~ s/([\d])//) {
            $sudoku[$i][$j] = $1;
        }
        
    }
    
}





