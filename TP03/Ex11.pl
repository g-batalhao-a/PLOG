achata_lista([],[]).
achata_lista(X,[X]):-atomic(X).
achata_lista([Cab|Rest],LElem):-
    achata_lista(Cab,L1),
    achata_lista(Rest,L2),
    append(L1,L2,LElem).
    