#!/usr/bin/perl

#
# Mateus Barros Rodrigues - 7991037
# Vinícius Jorge Vendramini - 7991103
#
# EP2
#

# GG

use warnings;

my @intervalos;
my @linhas;

my $num_vars = 0;

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

itera($num_vars, \%intervalos, @valores);






#    GG


sub itera {
    
    print "HUE\n";
    
    my $num_vars = shift;
    my $hash = shift;
    my $array = shift;
        
    my @intervalos = \$hash;
    my @valores = \$array;
    
    my $key = 0;
        
    print "Kelly ".$key."\n";
        
    while ($key < $num_vars) {
        if (defined $valores[$key]) {
            print "valores [".$key."] = ".$valores[$key]."\n";
            $key = $key + 1;
        }
        else {
            last;
        }
    }
    # key agora é a posição da primeira variável indefinida
    
    print "Kelly ".$key."\n";
    
    print "Kelly\n";
    
    if ($num_vars == $key) {
        # Fim da recursão; substitui os valores e GG.
        print @valores."\n";
    }
    else {
        # Faz a recursão mais uma vez.
        my $i;
        for ($i = $intervalos[$key][1]; $i < $intervalos[$key][2]; $i++) {
            $valores[$key] = $i;
            itera($num_vars, @intervalos, @valores);
        }
        
        $valores[$key] = undef;
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
