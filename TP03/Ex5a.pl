membro(X,L) :-
    L=[Y|Z],
    (
        X==Y;
        membro(X,Z)
    ).
