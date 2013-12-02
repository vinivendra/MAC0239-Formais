#!/usr/bin/perl

#
# Mateus Barros Rodrigues - 7991037
# Vinícius Jorge Vendramini - 7991103
#
# EP2
#

# GG

use warnings;
#use List::MoreUtils qw(firstidx);


# Hash que guarda os nomes das variáveis (keys) e seus valores
our %variaveis;
# A última linha que foi impressa, para evitar repetições
our $ultima_linha = "";

# Array que guarda as linhas que devem ser impressas no arquivo saida.txt
our @saida;

# Array que guarda os domínios de cada variável
my @intervalos;
# Array que guarda as linhas que precisam ser impressas, lidas do arquivo de entrada
my @linhas;

# A cada linha lida, guarda só as variáveis que estão presentes nela,
# para evitar iterações desnecessárias
my @varsPorLinha;
# Analogamente, guarda só os domínios daquela linha
my @intervalosPorLinha;

# Guarda o número total de variáveis
my $num_vars = 0;

# Hash para permitir a conversão do arquivo de saída para a cnf
my %cnf;

sub firstidx{
    
    my $quem = shift;
    my $ondeRef = shift;
    my @onde = @$ondeRef;

# Contadores
my $k;
my $i;
my $j;
my $l;

    my $pos = 0;

    while(1){
	if($onde[$pos] eq $quem){ return $pos; }
	if($pos >= @onde){ return -1; }
	$pos++;
    }
    
}

my @vars;

#my $bla = firstidx("comigo",\@hue
#my $c = firstidx { $_ eq "-c" } @ARGV;
my $c = firstidx("-c",\@ARGV);

# Lê cada linha do arquivo de entrada
while (<>) {
    
    # Se a linha for uma nova variável
    if ($_ =~ /([A-Z]+)\:\s+(\d+)\s+(\d+)\./) {
        # $1 = nome da variável, $2 = começo do domínio, $3 = final do domínio.
        
        # Adiciona ela no vetor de domínios
        $intervalos[$num_vars] = [$1, $2, $3];
        
        # Soma um no número total de variáveis
        $num_vars ++;
    } # Caso contrário, é um predicado
    else {
        # Adiciona ele na lista de linhas que precisamos imprimir
        @linhas = (@linhas, $_);
    }
    
}




# Para cada uma das linhas, imprime as combinações
for ($i = 0; $i < @linhas; $i++) {
    # Zera os vetores que devem ser recriados a cada linha
    @varsPorLinha = ();
    @valores = ();
    
    # Faz uma cópia da linha para podermos alterar à vontade
    $a = $linhas[$i];
    # Retira as restrições dessa cópia
    $a =~ s/((^\.)*)\.(.*)/$1/;
    
    # Retira cada variável da linha e guarda ela no vetor
    # de variáveis dessa linha
    while($a =~ s/([A-Z]+)/0/) {
        push(@varsPorLinha, $1);
    }
    
    # Percorre o vetor de intervalos e vai fazendo match com o 
    # de variáveis dessa linha. A cada variável encontrada,
    # coloca o domínio dela no vetor de domínios por linha.
    for ($j = 0; $j < @intervalos; $j++) {
        for ($l = 0; $l < @varsPorLinha; $l++) {
            if ($varsPorLinha[$l] eq $intervalos[$j][0]) {
                push(@intervalosPorLinha, $intervalos[$j]);
                last;
            }
        }
    }
    
    # Imprime a linha sendo lida na stdout, para termos noção
    # de como está indo o processo. Útil com arquivos que demoram.
    print "Processando a linha: $linhas[$i]";
    
    # Chama a função principal, que passa pelas combinações de variáveis
    # e substitui/imprime a linha atual.
    itera($linhas[$i], @intervalosPorLinha, @valores);
}




# Nesse ponto, todas as linhas foram colocadas no vetor @saida,
# exatamente como elas devem ser impressas. Antes de imprimi-las, 
# precisamos saber se é necessário passar o output para o formato cnf.

open (LPO, '>lpo.txt');
print LPO @saida;
close (LPO);


open (SAIDA, '>saida.txt');


# Caso seja necessário:
if ($c >= 0) {
    print "Passando para a cnf...\n";
    
    $k = 0;
    
    # Percorre as linhas do vetor de saída, e vai colocando cada
    # cláusula num hash.
    while(($a = $saida[$k++]) && ($k < @saida)) {
        while ($a =~ s/([a-z]+\([^a-z]+\))//) {
            $cnf{$1} = 1;
        }
    }
    
    # Agora que as clásulas estão no hash, podemos simplesmente
    # criar um vetor com os seus elementos. Assim, cada índice do
    # vetor será o número equivalente a essa cláusula no nosso formato cnf.
    
    # @vars será esse vetor
    @vars = sort keys %cnf;
    
    my $var;
    my @vars = sort keys %cnf;
   
    $k = 0;
    
    # Percorre a saída e vai substituindo as cláusulas pelos números
    while($k < @saida) {
        $a = $saida[$k];
        
        # A cada cláusula achada, faz a substituição
        while ($a =~ /([a-z]+\([^a-z]+\))/) {
            #$i = firstidx { $_ eq $1 } @vars;
	    $i = firstidx($1,\@vars);
            $i++;
            $a =~ s/[a-z]+\([^a-z]+\)/$i/;
        }
        
        # Coloca um '0' no fim de cada linha
        $a =~ s/(.*)\./$1 0/;
        
        # Substitui a linha nova no arquivo de saída
        $saida[$k] = $a;
        
        $k++;
    }
    
    # Pega as informações necessárias para o cabeçalho da cnf
    $num_variaveis = @vars;
    $num_clausulas = @saida;
    # Imprime o cabeçalho
    print SAIDA "p cnf $num_variaveis $num_clausulas\n";
}


# Nesse ponto do programa, o vetor @saida está com as linhas que devem ser impressas,
# que podem ou não ter sido substituídas pelos números. Assim, basta imprimir essas linhas.
print SAIDA @saida;
close (SAIDA);

print "Arquivo gerado!\n";



if($s >= 0) {
    print "Passando o sudoku para o zchaff...\n";
    
    $resposta = `zchaff saida.txt`;
    
    $a = $resposta;
    
    $a =~ /([-\d\s]*)Random/;
    
    $a = $1;
    
    print "$1\n";
    
    print "resposta:\n";
    
    while ($a =~ s/(-)?(\d+)\s*//) {
        if (!(defined $1)) {
            print "$vars[$2 - 1]\n";
        }
    }
}










#
#
#
#  Implementação das funções
#
#
#





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
    
    my $linha = shift;          # String contendo a linha em que vamos substituir os valores
    my $intervalos = shift;     # Vetor contendo os nomes das variáveis e seus respectivos domínios
    my $valores = shift;        # Vetor contendo os valores das variáveis que já foram "decididos" até agora
    
    my $key = 0;                # Posição no vetor da variável que vamos iterar nesse passo da recursão
    
    my $num_vars = @intervalos;       # Número total de variáveis
    
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
            itera($linha, @intervalos, @valores);
        }
        
        # Retira o valor da variável atual para poder voltar no passo anterior da recursão
        $valores[$key] = undef;
    }
    
}





# Subrotina para substituir os valores da variável na linha e imprimi-la
# 
# A ideia básica é primeiro reirar as restrições da linha, substituir os
# valores adequados e avaliá-las. Se as restrições forem satisfeitas, substituimos
# os valores nas variáveis e imprimimos a linha.
#
# Para as substituições, vamos usar um hash (%variaveis) que relaciona o
# nome da variável (key) com seu valor.
sub imprime {
    
    my $num_vars = shift;       # Número total de variáveis declaradas no arquivo de entrada
    my $linha = shift;          # String contendo a linha a ser impressa
    my $intervalos = shift;     # Vetor com os intervalos de cada variável
    my $valores = shift;        # Vetor com os valores atuais de cada variável
    
    my $i;
    
    # Substitui os valores velhos das variáveis pelos atuais no nosso hash de variáveis
    for ($i = 0; $i < @intervalos; $i++) {
        $variaveis{$intervalos[$i][0]} = $valores[$i];
    }
    
    
    my $a = $linha;             # Cópia da string, para podermos modificá-la à vontade
    my $b;                      # Idem.
    my @restricoes;             # Vetor para guardar as restrições que serão analisadas
    
    my $j = 0;
    
    $a =~ s/(.*)[^\.]$/$1./;    # Se a linha não tem um ponto final, colocamos.
    
    # Retira as restrições da linha e guarda elas no vetor de restrições.
    while ($a =~ /(.*\.)(.*[,])?(\s*[A-Z]+.*[,\.])/) {      # Enquanto ainda houver uma restrição
        if (defined $2) {                                   # Retira a primeira; se ainda houver outras,
            $a =~ s/(.*\.)(.*[,])?(\s*[A-Z]+.*[,\.])/$1$2/; # coloca elas de volta no final.
        }
        else {                                              # Se não, é só tirar.
            $a =~ s/(.*\.)(.*[,])?(\s*[A-Z]+.*[,\.])/$1/;
        }
        
        $b = $3;                    # $b é a restrição retirada
        $b =~ s/(.*)[,.]/$1/;       # Tiramos pontos finais ou vírgulas do fim dela
        $restricoes[$j++] = $b;     # Guardamos ela no vetor
    }
    
    
    my $pode_imprimir = 1;          # Variável que vamos usar para descobrir se as
                                    # restrições foram todas satisfeitas
    for ($j = 0; $j < @restricoes; $j++) {      # Percorre o vetor de restrições
        while ($restricoes[$j] =~ s/([A-Z]+)/$variaveis{$1}/) {     # Substitui o nome de cada variável pelo
        }                                                           # seu valor, que estava guardado no hash
        
        $restricoes[$j] =~ s/^([^\!\>\<]*)\=(.*)/$1\=\=$2/;         # Se acharmos um '=' sozinho, colocamos
                                                                    # outro do lado, para o perl poder avaliar
        if(!(eval $restricoes[$j])) {       # Manda o perl avaliar a expressão; desse modo, suportamos qualquer
            $pode_imprimir = 0;             # operador que ele suportar.
            last;                           # Se acharmos uma restrição que não for satisfeita, podemos parar de procurar
        }
    }
    
    
    # Se nenhuma restrição ficou insatisfeita, podemos substituir os valores e imprimir a linha
    if ($pode_imprimir == 1) {

        while ($a =~ s/([A-Z]+)/$variaveis{$1}/) {  # Substitui os valores das variáveis
        }
        
        $a =~ s/([^\.]+)(\.\.)$/$1./;               # Retira um '.' a mais que pode ter aparecido no fim da linha
        
        if (!($a eq $ultima_linha)) {               # Se essa linha for igual à anterior, ela já foi impressa
            $ultima_linha = $a;                     # então não precisamos imprimir de novo.
            
            $saida[$k++] = "$a\n";                  # Caso contrário, guardamos a linha no vetor @saida para
                                                    # poder imprimi-la depois.
        }
    }
    

    
}





