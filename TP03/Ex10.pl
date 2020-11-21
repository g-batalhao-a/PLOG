ordenada([N]).
ordenada([N1,N2]):-N1@=<N2.
ordenada([N1,N2|T]):-
    N1@=<N2,
    ordenada([N2|T]).

ordena(L1,L2):-
    length(L1, Times),
    order(L1,[],L2,Times).



order([N1,N2|T],Cop,L2,Times):-
    (
        (
            N2<N1,
            append(Cop,[N2],NewCop),
            order([N1|T],NewCop,L2,Times)
        );
        (
            append(Cop,[N1],NewCop),
            order([N2|T],NewCop,L2,Times)
        )
    ).
order([N1,N2],Cop,L2,Times):-
    (
        (
            N2<N1,
            append(Cop,[N2,N1],NewCop),
            order([],NewCop,L2,Times)
        );
        (
            append(Cop,[N1,N2],NewCop),
            order([],NewCop,L2,Times)
        )
    ).

order([],L2,L2,0).
order([],Cop,L2,Times):- 
    NewTime is Times-1,
    order(Cop,[],L2,NewTime).
