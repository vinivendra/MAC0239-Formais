#!/usr/bin/perl

#
# Mateus Barros Rodrigues - 7991037
# Vinícius Jorge Vendramini - 7991103
#
# EP2
#

# GG

use warnings;
use List::MoreUtils qw(firstidx);

our %variaveis;
our $ultima_linha = "";

our @saida;
our $k;

my @intervalos;
my @linhas;

my $num_vars = 0;

my %cnf;

my $c = firstidx { $_ eq "-c" } @ARGV;

while (<>) {
    
    
    if ($_ =~ /([A-Z]+)\:\s+(\d+)\s+(\d+)\./) {
        # Nova Variável
        # $1 = nome da variável, $2 = começo do domínio, $3 = final do domínio.
        
        $intervalos[$num_vars] = [$1, $2, $3];
        
        $num_vars ++;
    }
    else {
        @linhas = (@linhas, $_);
    }
    
    
}

my $i;

# Para cada uma das linhas, imprime as combinações
for ($i = 0; $i < @linhas; $i++) {
    itera($num_vars, $linhas[$i], @intervalos, @valores);
}


open (SAIDA, '>saida.txt');

if ($c >= 0) {
    $k = 0;
    
    while(($a = $saida[$k++]) && ($k < @saida)) {
        while ($a =~ s/([a-z]+\([^a-z]+\))//) {
            $cnf{$1} = 1;
        }
    }
    
    my $var;
    my @vars = sort keys %cnf;
    $k = 0;
    
    while($k < @saida) {
        $a = $saida[$k];
        
        while ($a =~ /([a-z]+\([^a-z]+\))/) {
            $i = firstidx { $_ eq $1 } @vars;
            $i++;
            $a =~ s/[a-z]+\([^a-z]+\)/$i/;
        }
        
        $a =~ s/(.*)\./$1 0/;
        
        $saida[$k] = $a;
        
        $k++;
    }
    
    $num_variaveis = @vars;
    $num_clausulas = @saida;
    print SAIDA "p cnf $num_variaveis $num_clausulas\n";
}

print SAIDA @saida;
close (SAIDA);













# Subrotina recursiva para possibilitar a impressão de todas as combinações de variáveis.
# 
# A cada passo da recursão se escolhe uma variável e se cria uma iteração
# sobre os possíveis valores que essa variável pode tomar. Por exemplo, se a variável X
# pode ir de 1 a 3, criamos um for de 1 a 3. A cada passo do for guardamos o valor atual de
# X num vetor e passamos esse vetor para o próximo passo da recursão.
# 
# Quando todas as variáveis estiverem com seus valores decididos, ou seja, dentro do último
# for, imprimimos a linha em questão com os valores das variáveis.
sub itera {
    
    my $num_vars = shift;       # Número total de variáveis
    my $linha = shift;          # String contendo a linha em que vamos substituir os valores
    my $intervalos = shift;     # Vetor contendo os nomes das variáveis e seus respectivos domínios
    my $valores = shift;        # Vetor contendo os valores das variáveis que já foram "decididos" até agora
    
    my $key = 0;                # Posição no vetor da variável que vamos iterar nesse passo da recursão
    
    # Descobre qual deve ser o valor de key
    while ($key < $num_vars) {
        if (defined $valores[$key]) {
            $key = $key + 1;
        }
        else {
            last;
        }
    }
    
    # Key agora é a posição da primeira variável indefinida
    # Se já tivemos ocupado todas as variáveis, basta imprimir:
    if ($num_vars == $key) {
        imprime($num_vars, $linha, @intervalos, @valores);
    }
    # Se ainda precisar fazer mais vezes
    else {
        my $i;
        
        # Faz a iteração dentro do intervalo da variável
        for ($i = $intervalos[$key][1]; $i <= $intervalos[$key][2]; $i++) {
            # Coloca o valor da variável no nosso vetor de variáveis
            $valores[$key] = $i;
            # Chama o próximo passo da recursão
            itera($num_vars, $linha, @intervalos, @valores);
        }
        
        # Retira o valor da variável atual para poder voltar no passo anterior da recursão
        $valores[$key] = undef;
    }
    
}





# Subrotina para substituir os valores da variável na linha e imprimi-la
#
# Para isso, vamos usar um hash (%variaveis) que relaciona o nome da variável (key)
# com seu valor.
sub imprime {
    
    my $num_vars = shift;
    my $linha = shift;
    my $intervalos = shift;
    my $valores = shift;
    
    my $i;
    
    # Coloca os valores atuais das variáveis no nosso hash de variáveis
    for ($i = 0; $i < @intervalos; $i++) {
        $variaveis{$intervalos[$i][0]} = $valores[$i];
    }
    
    
    my $a = $linha; 
    my $b;
    my @restricoes;
    my $j = 0;
    
    $a =~ s/(.*)[^\.]$/$1./;
    
    # Retira as restrições da linha e guarda elas no vetor
    while ($a =~ /(.*\.)(.*[,])?(\s*[A-Z]+.*[,\.])/) {
        if (defined $2) {
            $a =~ s/(.*\.)(.*[,])?(\s*[A-Z]+.*[,\.])/$1$2/;
        }
        else {
            $a =~ s/(.*\.)(.*[,])?(\s*[A-Z]+.*[,\.])/$1/;
        }
        
        $b = $3;
        $b =~ s/(.*)[,.]/$1/;
        $restricoes[$j++] = $b;
    }
    
    
    my $pode_imprimir = 1;
    for ($j = 0; $j < @restricoes; $j++) {
        while ($restricoes[$j] =~ s/([A-Z]+)/$variaveis{$1}/) {
        }
        
        $restricoes[$j] =~ s/^([^\!\>\<]*)\=(.*)/$1\=\=$2/;
                
        if(!(eval $restricoes[$j])) {
            $pode_imprimir = 0;
        }
    }
    
    
    
    if ($pode_imprimir == 1) {
        # Substitui os valores das variáveis
        while ($a =~ s/([A-Z]+)/$variaveis{$1}/) {
        }
        
        $a =~ s/([^\.]+)(\.\.)$/$1./;
        
        if (!($a eq $ultima_linha)) {
            $ultima_linha = $a;
            
            #Imprime a linha
            $saida[$k++] = "$a\n";
        }

    }
    

    
}






#for $family ( keys %intervalos ) {
#    print "$family: @{ $intervalos{$family} }\n";
#}

#else {
#    # Expressão
#    while ($_ =~ s/(-)?([a-z]+)\(//) {
#        # $1 = '-' (ou não), $2 = nome do predicado
#        if (defined $1) {
#            $ultimo_predicado = $1.$2;
#            print "Predicado: ".$1.$2." ";
#        }
#        else {
#            $ultimo_predicado = $2;
#            print "Predicado: ".$2." ";
#        }
#        
#        while ($_ =~ s/([A-Z]+)\s*,?\s*//) {
#            # $1 = Nome da variável
#            print $1." ";
#            if ($_ =~ s/^\)\s*//){
#                print "\n";
#                last;
#            }
#        }
#    }
#    
#    if ($_ =~ s/\.\s*//) {
#        # Come o ponto
#        
#        $_ =~ s/(.*)\n//;
#        print $1."\n";
#        # Come até a próxima linha
#    }
#}
