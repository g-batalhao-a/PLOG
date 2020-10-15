conta([],0).

conta(L,N) :-
    L=[X|L1],
    N1 is N-1,
    conta(L1,N1).

membro(X,L) :- append(_, [X|_],L).

conta_elem(X,L,0) :- 
    \+ membro(X,L).

conta_elem(X,L,N) :-
    append(La,[X|Lb],L),
    append(La,Lb,L2),
    N1 is N-1,
    conta_elem(X,L2,N1).