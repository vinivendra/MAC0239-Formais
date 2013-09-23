#!/usr/bin/perl

use warnings;
use strict;

# Matriz usada na leitura da entrada
my @sudoku = ([], [], [], [], [], [], [], [], []);

# Contadores
my $i;
my $j;
my $k;
my $l;
my $m;
my $n;
my $o;

# Variável para facilitar nos cálculos
my $base = 0;



# Leitura da entrada
my $a = (<>);

for ($i = 0; $i < 9; $i++) {        # $a deve ter 81 dígitos, então percorremos 9x9
    for ($j = 0; $j < 9; $j++) {
        
        if ($a =~ s/([\d])//) {     # Extrai o número de $a e joga na matriz
            $sudoku[$i][$j] = $1;
        }
        
    }
}



# Gerenciamento de arquivo

open (SAIDA, '>saida.txt');


#
# Geração do sudoku
#

# Cálculo do número de cláusulas
# Percorre a matriz sudoku procurando por dicas, a cada dica encontrada soma um no $k
$k = 0;

for ($i = 0; $i < 9; $i ++) {
    for ($j = 0; $j <9; $j ++) {
        if ($sudoku[$i][$j] != 0) { $k ++; }
    }
}

# $k é o número de dicas, cada dica adiciona 32 cláusulas ao total inicial de 11259
$k = 11259 + $k * 32;

# Agora que sabemos, podemos imprimir o cabeçalho
print SAIDA "p cnf 729 ".$k."\n";


#
# Cláusulas das dicas
#

for ($i = 0; $i < 9; $i ++) {    # Percorre a matriz; para cada dica encontrada, adiciona as cláusulas
    for ($j = 0; $j <9; $j ++) {
        if ($sudoku[$i][$j] != 0) {
            
            for ($k = 0; $k < 9; $k++) {    # Cláusulas para a mesma célula
                                            # $k percorre as variáveis de todos os números da célula
                if ($k + 1 != $sudoku[$i][$j]) {    # Fazemos a negação de todos os OUTROS números
                    print SAIDA "-".($i*81 + $j*9 + $k + 1)." 0\n";
                }
            }
            
            for ($k = 0; $k < 9; $k ++) {   # Para o mesmo número na mesma linha
                							# $k percorre cada célula da linha
                if ($k != $j) {    			# Fazemos a negação de todas as OUTRAS células da mesma linha,
                                            # ou seja, excluindo a célula (i,j)
                    print SAIDA "-".($i*81 + $k*9 + $sudoku[$i][$j])." 0\n";
                }
            }
            
            for ($k = 0; $k < 9; $k ++) {   # Para o mesmo número na mesma coluna
                							# $k Percorre cada célula da coluna
                if ($k != $i) {   		    # Fazemos a negação de todas as OUTRAS células da mesma coluna
                    print SAIDA "-".($j*9 + $k*81 + $sudoku[$i][$j])." 0\n";
                }
            }
            
            
            # Descobrir em qual bloco a dica está
            
            if ($i < 3) { $m = 0; }
            elsif ($i < 6) { $m = 1; }
            else { $m = 2; }
            
            if ($j < 3) { $n = 0; }
            elsif ($j < 6) { $n = 1; }
            else { $n = 2; }
            
            for ($k = 0; $k < 3; $k ++) {   	# Para o mesmo número, em todas as células do bloco (m,n)
                for ($l = 0; $l < 3; $l ++) {	# $k representa a linha atual, $l a coluna, com relação ao bloco (m,n)
                    if (!($m*3 + $k == $i && $n*3 + $l == $j)) {    # Em todas as OUTRAS células do bloco
                        print SAIDA "-".(($m*3 + $k)*81 + ($n*3+$l)*9 + $sudoku[$i][$j])." 0\n";
                    }
                }
            }
            
            print SAIDA "\n";
            
        }
    }
}

#
# Construção do resto do sudoku
#

# Exatamente um número em cada célula
for ($i = 0; $i < 9; $i ++) {
    for ($j = 0; $j <9; $j ++) {
        $base = $i * 81 + $j * 9;           # A base indica a variável correspondente ao começo da célula (i,j)
        
        # Pelo menos um
        for ($k = 0; $k < 9; $k ++) {       # Percorre todos os dígitos
            print SAIDA ($base + $k + 1)." ";
        }
        print SAIDA "0\n";
        
        # No máximo um
        for ($k = 0; $k < 9; $k ++) {		# $k e $l percorrem todos os dígitos, sem repetir combinações,
            for ($l = $k; $l < 9; $l ++) {	# para podermos pegar todas as combinações dos 9 dígitos 2 a 2
                if ($k != $l) { print SAIDA "-".($base + $k + 1)." -".($base + $l + 1)." 0\n"; }
            }
        }
        
    }
}


# Dígitos diferentes em cada linha
for ($i = 0; $i < 9; $i ++) {               # Para cada linha
    for ($j = 0; $j <9; $j ++) {            # Para cada um dos nove dígitos
        
        $base = $i * 81;                    # Base indica o começo da linha
        
        # Pelo menos um por linha
        for ($k = 0; $k < 9; $k ++) {       # Para cada célula da linha
            print SAIDA ($base + $k*9 + $j + 1)." ";
        }
        print SAIDA "0\n";
        
        # No máximo um por linha
        for ($k = 0; $k < 9; $k ++) {       # Para cada célula da linha,
            for ($l = $k; $l < 9; $l ++) {  # fazendo as combinações de 9, 2 a 2.
                if ($k != $l) { print SAIDA "-".($base + $k*9 + $j + 1)." -".($base + $l*9 + $j + 1)." 0\n"; }
            }
        }
        
    }
    
}

# Dígitos diferentes em cada coluna
for ($i = 0; $i < 9; $i ++) {               # Para cada coluna
    for ($j = 0; $j <9; $j ++) {            # Para cada um dos nove dígitos
        
        $base = $i * 9;                     # Base indica o começo da coluna
        
        # Pelo menos um por coluna
        for ($k = 0; $k < 9; $k ++) {       # Para cada célula da coluna
            print SAIDA ($base + $k*81 + $j + 1)." ";
        }
        print SAIDA "0\n";
        
        # No máximo um por coluna
        for ($k = 0; $k < 9; $k ++) {       # Para cada célula da coluna,
            for ($l = $k; $l < 9; $l ++) {  # fazendo as combinações de 9, 2 a 2
                if ($k != $l) { print SAIDA "-".($base + $k*81 + $j + 1)." -".($base + $l*81 + $j + 1)." 0\n"; }
            }
        }
        
    }
    
}

# Dígitos diferentes em cada bloco
for ($i = 0; $i < 3; $i ++) {                   # Para cada linha de blocos
    for ($j = 0; $j < 3; $j ++) {               # Para cada coluna de blocos
        
        $base = $i*81*3 + $j*9*3;               # Base indica o começo da célula superior esquerda do bloco
        
        for ($m = 0; $m < 9; $m ++) {           # Para cada um dos nove dígitos
            
            # Pelo menos um por bloco
            for ($k = 0; $k < 3; $k ++) {       # Percorre as células dentro de cada bloco
                for ($l = 0; $l < 3; $l ++) {
                    print SAIDA ($base + $k*81 + $l*9 + $m + 1)." ";
                }
            }
            
            print SAIDA "0\n";
            
            # No máximo um por bloco
            for ($k = 0; $k < 3; $k ++) {       # Percorre as células dentro de cada bloco
                for ($l = 0; $l < 3; $l ++) {
                    
                    for ($n = $k; $n < 3; $n ++) {     # Percorre as células dentro de cada bloco de novo,
                        for ($o = $l; $o < 3; $o ++) { # para pegarmos as combinações
                            if (!($k == $n && $l == $o)) { print SAIDA "-".($base + $k*81 + $l*9 + $m + 1)." -".($base + $n*81 + $o*9 + $m + 1)." 0\n"; }
                        }
                    }
                    
                }
            }
            
        }
        
    }
}


#
# Encerramento
#

close (SAIDA);

