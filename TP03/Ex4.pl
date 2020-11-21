inverter(L1,L2):-
    inv(L1,[],L2).

inv([H|T],I,R):-
    inv(T,[H|I],R).
inv([],R,R).