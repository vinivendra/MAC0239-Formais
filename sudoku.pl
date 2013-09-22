
use warnings;
use strict;

# Tabuleiro
my @sudoku = ([], [], [], [], [], [], [], [], []);

# Contadores
my $i;
my $j;
my $k;
my $l;
my $m;
my $n;
my $o;

my $base = 0;

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

# Número de cláusulas

$k = 0;

for ($i = 0; $i < 9; $i ++) {
    for ($j = 0; $j <9; $j ++) {
        if ($sudoku[$i][$j] != 0) { $k ++; }
    }
}

$k = 11259 + $k * 32;

print SAIDA "p cnf 729 ".$k."\n";


# Cláusulas de dica

for ($i = 0; $i < 9; $i ++) {
    for ($j = 0; $j <9; $j ++) {
        if ($sudoku[$i][$j] != 0) {
            
            for ($k = 0; $k < 9; $k++) {
                if ($k + 1 != $sudoku[$i][$j]) {
                    print SAIDA "-".($i*81 + $j*9 + $k + 1)." 0\n";
                }
            }
            
            for ($k = 0; $k < 9; $k ++) {
                if ($k != $j) {
                    print SAIDA "-".($i*81 + $k*9 + $sudoku[$i][$j])." 0\n";
                }
            }
            
            for ($k = 0; $k < 9; $k ++) {
                if ($k != $i) {
                    print SAIDA "-".($j*9 + $k*81 + $sudoku[$i][$j])." 0\n";
                }
            }
            
            if ($i < 3) { $m = 0; }
            elsif ($i < 6) { $m = 1; }
            else { $m = 2; }
            
            if ($j < 3) { $n = 0; }
            elsif ($j < 6) { $n = 1; }
            else { $n = 2; }
            
            for ($k = 0; $k < 3; $k ++) {
                for ($l = 0; $l < 3; $l ++) {
                    if (!($m*3 + $k == $i && $n*3 + $l == $j)) {
                        print SAIDA "-".(($m*3 + $k)*81 + ($n*3+$l)*9 + $sudoku[$i][$j])." 0\n";
                    }
                }
            }
            
            
            print SAIDA "\n";
            
            
        }
    }
}




# Um número em cada célula
for ($i = 0; $i < 9; $i ++) {
    for ($j = 0; $j <9; $j ++) {
        $base = $i * 81 + $j * 9;
        
        for ($k = 0; $k < 9; $k ++) {
            print SAIDA ($base + $k + 1)." ";
        }
        print SAIDA "0\n";
        
        for ($k = 0; $k < 9; $k ++) {
            for ($l = $k; $l < 9; $l ++) {
                if ($k != $l) { print SAIDA "-".($base + $k + 1)." -".($base + $l + 1)." 0\n"; }
            }
        }
        
    }
}

# Dígitos diferentes em cada linha
for ($i = 0; $i < 9; $i ++) {    # Percorre as linhas
    
    # Para cada um dos nove dígitos
    for ($j = 0; $j <9; $j ++) {
        $base = $i * 81;
        
        for ($k = 0; $k < 9; $k ++) {
            print SAIDA ($base + $k*9 + $j + 1)." ";
        }
        print SAIDA "0\n";
        
        for ($k = 0; $k < 9; $k ++) {
            for ($l = $k; $l < 9; $l ++) {
                if ($k != $l) { print SAIDA "-".($base + $k*9 + $j + 1)." -".($base + $l*9 + $j + 1)." 0\n"; }
            }
        }
        
    }
    
}

# Dígitos diferentes em cada colunas
for ($i = 0; $i < 9; $i ++) {    # Percorre as colunas
    
    # Para cada um dos nove dígitos
    for ($j = 0; $j <9; $j ++) {
        $base = $i * 9;
        
        for ($k = 0; $k < 9; $k ++) {
            print SAIDA ($base + $k*81 + $j + 1)." ";
        }
        print SAIDA "0\n";
        
        for ($k = 0; $k < 9; $k ++) {
            for ($l = $k; $l < 9; $l ++) {
                if ($k != $l) { print SAIDA "-".($base + $k*81 + $j + 1)." -".($base + $l*81 + $j + 1)." 0\n"; }
            }
        }
        
    }
    
}

# Dígitos diferentes em cada bloco
for ($i = 0; $i < 3; $i ++) {    # Percorre os blocos
    for ($j = 0; $j < 3; $j ++) {
        
        $base = $i*81*3 + $j*9*3;
        
        for ($m = 0; $m < 9; $m ++) {    # Para todos os dígitos
            
            for ($k = 0; $k < 3; $k ++) {    # Percorre as células dentro de cada bloco
                for ($l = 0; $l < 3; $l ++) {
                    print SAIDA ($base + $k*81 + $l*9 + $m + 1)." ";
                }
            }
            
            print SAIDA "0\n";
            
            for ($k = 0; $k < 3; $k ++) {    # Percorre as células dentro de cada bloco
                for ($l = 0; $l < 3; $l ++) {
                    
                    for ($n = $k; $n < 3; $n ++) {    # Percorre as células dentro de cada bloco de novo
                        for ($o = $l; $o < 3; $o ++) {
                            if (!($k == $n && $l == $o)) { print SAIDA "-".($base + $k*81 + $l*9 + $m + 1)." -".($base + $n*81 + $o*9 + $m + 1)." 0\n"; }
                        }
                    }
                    
                }
            }
            
        }
        
    }
}



# Encerramento

close (SAIDA);

