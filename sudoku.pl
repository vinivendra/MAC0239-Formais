
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

# Gerenciamento de arquivo

open (SAIDA, '>saida.txt');




# Geração do sudoku inicial

my @contador = (0, 0, 0, 0, 0, 0, 0, 0, 0);
my $numeroDeUns = 0;

for ($contador[0] = 0; $contador[0] < 2; $contador[0]++, $numeroDeUns++) {
    for ($contador[1] = 0; $contador[1] < 2; $contador[1]++, $numeroDeUns++) {
        for ($contador[2] = 0; $contador[2] < 2; $contador[2]++, $numeroDeUns++) {
            for ($contador[3] = 0; $contador[3] < 2; $contador[3]++, $numeroDeUns++) {
                for ($contador[4] = 0; $contador[4] < 2; $contador[4]++, $numeroDeUns++) {
                    for ($contador[5] = 0; $contador[5] < 2; $contador[5]++, $numeroDeUns++) {
                        for ($contador[6] = 0; $contador[6] < 2; $contador[6]++, $numeroDeUns++) {
                            for ($contador[7] = 0; $contador[7] < 2; $contador[7]++, $numeroDeUns++) {
                                for ($contador[8] = 0; $contador[8] < 2; $contador[8]++, $numeroDeUns++) {
                                    if ($numeroDeUns != 1) {
                                        if ($contador[0] == 0) { print SAIDA "-1 "; }
                                        if ($contador[0] == 1) { print SAIDA "1 "; }
                                        if ($contador[1] == 0) { print SAIDA "-2 "; }
                                        if ($contador[1] == 1) { print SAIDA "2 "; }
                                        if ($contador[2] == 0) { print SAIDA "-3 "; }
                                        if ($contador[2] == 1) { print SAIDA "3 "; }
                                        if ($contador[3] == 0) { print SAIDA "-4 "; }
                                        if ($contador[3] == 1) { print SAIDA "4 "; }
                                        if ($contador[4] == 0) { print SAIDA "-5 "; }
                                        if ($contador[4] == 1) { print SAIDA "5 "; }
                                        if ($contador[5] == 0) { print SAIDA "-6 "; }
                                        if ($contador[5] == 1) { print SAIDA "6 "; }
                                        if ($contador[6] == 0) { print SAIDA "-7 "; }
                                        if ($contador[6] == 1) { print SAIDA "7 "; }
                                        if ($contador[7] == 0) { print SAIDA "-8 "; }
                                        if ($contador[7] == 1) { print SAIDA "8 "; }
                                        if ($contador[8] == 0) { print SAIDA "-9\n"; }
                                        if ($contador[8] == 1) { print SAIDA "9\n"; }
                                    }
                                }
                                $numeroDeUns = $numeroDeUns - 2;
                            }
                            $numeroDeUns = $numeroDeUns - 2;
                        }
                        $numeroDeUns = $numeroDeUns - 2;
                    }
                    $numeroDeUns = $numeroDeUns - 2;
                }
                $numeroDeUns = $numeroDeUns - 2;
            }
            $numeroDeUns = $numeroDeUns - 2;
        }
        $numeroDeUns = $numeroDeUns - 2;
    }
    $numeroDeUns = $numeroDeUns - 2;
}


# Encerramento

close (SAIDA);

