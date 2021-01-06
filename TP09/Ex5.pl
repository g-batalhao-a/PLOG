:-use_module(library(clpfd)).
carros:-
    Cor = [ A, B, C, D ],    %posição = posição na fila; valor é cor
    Tam = [ E, F, G, H ],   %
    domain(Cor, 1, 4), domain(Tam, 1, 4), all_distinct(Cor), all_distinct(Tam),
    element(Index, Cor, 3), element(Index, Tam, 1),  % verde é menor
    
    element(I, Cor, 1), IndAntesAz #= I+1, IndDepoisAz #= I-1,                 % I é index do azul
    element(IndDepoisAz, Tam, TamDepois), element(IndAntesAz, Tam, TamAntes),
    TamAntes #< TamDepois,                            %imed antes azul menor imed dep azul
    
    Index #< I,       %verde depois do azul
    element(Yellow, Cor, 2), element(Black, Cor, 4), Yellow #< Black,    %amarelo dep. preto
    append(Cor, Tam, Vars),
    labeling([ ], Vars),
    write('Cores: '),write(Cor),nl,
    write('Tamanhos: '),write(Tam),nl.