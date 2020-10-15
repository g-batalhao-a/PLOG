membro(X,L) :-
    L=[Y|Z],
    (
        X==Y;
        membro(X,Z)
    ).

membro(X,L) :- append(_, [X|_],L).

last(L,X) :- append(_, [X],L).

nth_membro(1,[X|_],X).
nth_membro(N,[_|Y],X) :-
    N>1,
    N1 is N-1,
    nth_membro(N1,Y,X).