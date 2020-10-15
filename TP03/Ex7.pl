before(X,Y,L) :-
    append(_,[X|L1],L),
    append(_,[Y|_],L1).