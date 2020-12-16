:-use_module(library(clpfd)).

% [4.5,7.8,3.6,2.9]
% [4.9,7.2,4.3,3.1]

tasks:-
    Maria = [45,78,36,29],
    Joao = [49,72,43,31],
    Tarefas = [TM1,TM2, TJ1,TJ2],
    domain(Tarefas,1,4),
    all_distinct(Tarefas),
    element(TM1,Maria,X1),
    element(TM2,Maria,X2),
    element(TJ1,Joao,X3),
    element(TJ2,Joao,X4),
    Sum #= X1+X2+X3+X4,
    labeling([minimize(Sum)],Tarefas) ,write(Tarefas).
