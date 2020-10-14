nth_membro(1,[X|_],X).
nth_membro(N,[_|Y],X) :-
    N>1,
    N1 is N-1,
    nth_membro(N1,Y,X).