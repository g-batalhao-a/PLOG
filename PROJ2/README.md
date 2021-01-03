# PLOG_TP2_T3_Grapes_3

## Autores

Gonçalo Alves - up201806451
António Bezerra - up201806854

## Instruções de configuração

Para este trabalho não foram utilizadas configurações, nem fontes especiais, sendo apenas necessário o SICStus Prolog 4.6.

## Instruções de execução

O utilizador tem à sua disposição 3 predicados para testar a resolução de problemas ```testsolverX/0``` e 3 predicados para testar a geração de problemas ```testegeneratorX/0```, em que X representa um dígito de 1 a 3.

Para além disso, o utilizador também pode utilizar os predicados: ```grapesolver/1```, que recebe uma lista com o formato ```[[RED,YELLOW,YELLOW,GREEN],[D,RED,E],[GREEN,F],[G]]``` (para mais listas, pode consultar o ficheiro **[grape.pl](grape.pl)** na zona comentada com "Input"); e ```grapegenerator/2```, que recebe o número de linhas do puzzle a gerar e uma variável.