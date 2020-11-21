sub(_,_,[],L2,L2).
sub(X,Y,[H|L1],I,L2):-
    (
        (
            H == X,
            ToApp = Y
        );
        (
            ToApp = H
        )
    ),
    append([ToApp],I,New),
    sub(X, Y, L1, New, L2).

substitui(X,Y,L1,L2):-
    sub(X,Y,L1,[],L2).

elimina_duplicados([X|L1],L2):-
    elim(L1,[X],L2).


search(H,[H|Cop]).
search(H,[X|Cop]):-search(H,Cop).

elim([],L2,L2).
elim([H|L1],Cop,L2):-
    (
        (
            search(H,Cop),
            elim(L1,Cop,L2)
        );
        (
            append(Cop,[H],NewCop),
            elim(L1,NewCop,L2)
        )
    ).

