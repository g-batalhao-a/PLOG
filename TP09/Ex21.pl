:-use_module(library(clpfd)).

golomb(N):-
    length(L,N),
    element(1,L,0),
    domain(L,0,N),
    domain([X,Y],1,N),
    
    less(L),
    difference(L,1,1,N,CountList),
    all_distinct(CountList),

    labeling([],L),
    write(L).

difference(_,N,_,N,_).
difference(L,X,Y,N,L1):-
    Y=<X,
    NY is Y+1,
    difference(L,X,NY,N,L1).
difference(L,X,N,N,[Element|R]):-
    element(X,L,First),
    element(N,L,Second),
    Element#=Second-First,
    NX is X+1,
    difference(L,X,1,N,R).
difference(L,X,Y,N,[Element|R]):-
    element(X,L,First),
    element(Y,L,Second),
    Element#=Second-First,
    NY is Y+1,
    difference(L,X,Y,N,R).

less([]).
less([_]).
less([A,B]):-
    A#<B.
less([A,B|R]):-
    A#<B,
    less([B|R]).

