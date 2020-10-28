
unificavel([],_,[]).
unificavel([H|T], Termo, T1):-
    \+ H=Termo, !,
    unificavel(T,Termo,T1).
unificavel([H|T],Termo,[H|T1]):- unificavel(T,Termo,T1).