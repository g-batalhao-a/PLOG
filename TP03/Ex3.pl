apend([],LF,LF).
apend([X|L1],L2,[X|L3]):-
    apend(L1,L2,L3).
