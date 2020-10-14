delete_one(X,L1,L2) :-
    append(La,[X|Lb],L1),
    append(La,Lb,L2).
    