membro(X,L) :- append(_, [X|_],L).

delete_one(X,L1,L2) :-
    append(La,[X|Lb],L1),
    append(La,Lb,L2).


delete_all(X,L1,L2) :- 
    \+ membro(X,L1),L2=L1.

delete_all(X,L1,L2) :- 
    delete_one(X,L1,L3),
    delete_all(X,L3,L2).
     
