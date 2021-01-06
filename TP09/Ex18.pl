:- use_module(library(clpfd)).

/**
 * [2,1,2,0,0]
 * 
 * 0 - 2 zeros
 * 1 - 1 um
 * 2 - 2 dois
 * 3 - 0 tres
 * 4 - 0 quatros
 */

magicalSequence(N) :-
    length(Sequence, N),

    UpperBound is N - 1,
    domain(Sequence, 0, UpperBound),

    buildList(Sequence, Count, N),

    global_cardinality(Sequence, Count), 

    labeling([], Sequence),
    write(Sequence).


buildList(Sequence, Count, N) :-
    length(Count, N),
    createList(Count, Sequence, 0, N).

createList([],[],N,N).
createList([C|RestC], [S|RestS], Acc, Max) :-
    C = Acc-S,
    N1 is Acc + 1,
    createList(RestC, RestS, N1, Max).