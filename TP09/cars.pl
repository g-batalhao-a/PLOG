:-use_module(library(clpfd)).

/*
12 carros estão parados, em fila, num semáforo. Sabe-se que :
- A distribuição de cores é: 4 amarelos, 2 verdes, 3 vermelhos, 3 azuis
- O primeiro e último têm a mesma cor
- O segundo e o penúltimo têm a mesma cor
- O quinto é azul
- Todas as sub-sequências de 3 carros têm 3 cores diferentes
- Do primeiro para o último, a sequência amarelo-verde-vermelho-azul aparece uma única vez
*/

%Y - 2; G - 3 ; R - 4; B - 1

only_once(List,0):-
    length(List,L),
    L#<4.
    
only_once([A,B,C,D|T], Counter):-
    A #= 2 #/\ B #=3 #/\ C #=4 #/\ D #= 1 #<=> Bin,
    Counter #= Counter1 + Bin,
    only_once([B,C,D|T],Counter1).

three_diferent(List) :-
    length(List, L),
    L #< 3.
  three_diferent([A, B, C|T]) :-
    all_distinct([A, B, C]),
    three_diferent([B,C|T]).

cars:-
    length(L,12),
    global_cardinality(L, [2-4,3-2,4-3, 1-3]),
    element(1, L, X), element(12, L, X),
    element(2, L, Y), element(11, L, Y),
    element(5, L, 1),
    three_diferent(L),
    only_once(L,1),
    labeling([],L),
    write(L).
    
    
    
    
    
    