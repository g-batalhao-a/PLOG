:-use_module(library(clpfd)).
:- use_module(library(lists)).
/*
O programa em Prolog gera duas listas, L1 e L2, em que L1 tem o tamanho N e L2 tem o
tamanho N - 1.
Cada elemento de cada uma das listas tem que estar obrigatóriamente dentro do
intervalo [1;M]. O preenchimento destas listas é feito pelo predicado fill.
A soma de cada par de elementos da lista L1 é igual ao elemento da lista L2, de forma a
explicar melhor, veremos o seguinte exemplo:
Sendo N = 4, M = 10.
Uma possível solução seria: L1 = [1, 2, 4, 5] ; L2 = [3, 6, 9]
O predicado check garante que: 1+2 = 3 ; 2+4 = 6 ; 4+5 = 9
*/

% 2- M^(2N-1)

prog2(N,M,L1,L2) :-
    length(L1,N),
    N1 is N-1, length(L2,N1),

    Lists = [L1, L2],
    append(Lists, Vars),
    domain(Vars,1,M),

    all_distinct(Vars),
    check(L1,L2),

    element(1, L1, X),
    element(N, L1, Y),

    X #< Y,

    labeling([],Vars), write(L1), write(L2), nl, fail.

check([_],[]).
check([A,B|R],[X|Xs]) :-
    A+B #= X,
    check([B|R],Xs).

gym_pairs(MenHeights, WomenHeights, Delta, Pairs) :-
    length(MenHeights, NPeople),
    length(Pairs, NPeople),

    % Each position refers to a men. The value refers to the index of the women
    length(Men, NPeople),
    domain(Men, 1, NPeople),
    all_distinct(Men),

    constraint(1, Men, MenHeights, WomenHeights, Delta),

    labeling([], Men),

    buildList(Men, 1, [], Pairs).


constraint(_, [], _, _, _).

constraint(N, [Men | Rest], MenHeights, WomenHeights, Delta) :-
    element(N, MenHeights, MenHeight),
    element(Men, WomenHeights, WomenHeight),
    MenHeight #>= WomenHeight,
    MenHeight #=< WomenHeight + Delta,
    N1 is N + 1,
    constraint(N1, Rest, MenHeights, WomenHeights, Delta).



buildList([], _, Pairs, Pairs).

buildList([Men | Rest], N, Acc, Pairs) :-
    Pair = N-Men,
    append(Acc, [Pair], NewAcc),
    N1 is N + 1,
    buildList(Rest, N1, NewAcc, Pairs).


optimal_skating_pairs(MenHeights, WomenHeights, Delta, Pairs) :-
    length(MenHeights, NMens),
    length(WomenHeights, NWomens),

    NMens =< NWomens,

    length(Men, NMens),
    domain(Men, 1, NWomens),
    all_distinct(Men),

    constraintOptimal(1, Men, MenHeights, WomenHeights, Delta, [], Pairs), !,

    labeling([], Men).


optimal_skating_pairs(MenHeights, WomenHeights, Delta, Pairs) :-
    length(MenHeights, NMens),
    length(WomenHeights, NWomens),

    length(Women, NWomens),
    domain(Women, 1, NMens),
    all_distinct(Women),

    constraintOptimal1(1, Women, MenHeights, WomenHeights, Delta, [], Pairs), !,

    labeling([], Women).


constraintOptimal(_, [], _, _, _, Pairs, Pairs).

constraintOptimal(N, [Men | Rest], MenHeights, WomenHeights, Delta, Acc, Pairs) :-
    element(N, MenHeights, MenHeight),
    element(Men, WomenHeights, WomenHeight),
    (MenHeight #>= WomenHeight #/\ MenHeight #=< WomenHeight + Delta) #<=> B,
    (
        B = 1,
        append(Acc, [N-Men], NewAcc)
        ;
        true
    ),
    N1 is N + 1,
    constraintOptimal(N1, Rest, MenHeights, WomenHeights, Delta, NewAcc, Pairs).



constraintOptimal1(_, [], _, _, _, Pairs, Pairs).

constraintOptimal1(N, [Women | Rest], MenHeights, WomenHeights, Delta, Acc, Pairs) :-
    element(N, WomenHeights, WomenHeight),
    element(Women, MenHeights, MenHeight),
    (MenHeight #>= WomenHeight #/\ MenHeight #=< WomenHeight + Delta) #<=> B,
    (
        B = 1,
        append(Acc, [Women-N], NewAcc)
        ;
        true
    ),
    N1 is N + 1,
    constraintOptimal1(N1, Rest, MenHeights, WomenHeights, Delta, NewAcc, Pairs).
