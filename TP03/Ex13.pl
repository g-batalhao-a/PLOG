
lista_ate(N,L):-
    construir_lista(N,[],L).

construir_lista(0,L,L).
construir_lista(N,Cop,L):-
    append(Cop,[N],NewList),
    NewN is N-1,
    construir_lista(NewN,NewList,L).
    
lista_entre(N1,N2,L):-
    construir_lista(N1,N2,[],L).

construir_lista(N1,N2,L,L):-N2 is N1-1.
construir_lista(N1,N2,Cop,L):-
    append(Cop,[N2],NewList),
    NewN is N2-1,
    construir_lista(N1,NewN,NewList,L).

soma_lista(L,Soma):-
    soma(L, 0,Soma).

soma([],Soma,Soma).
soma([H|T],Acc,Soma):-
    NewAcc is H+Acc,
    soma(T,NewAcc,Soma).

par(N):- N mod 2 =:= 0.

lista_pares(N,L):-
    construir_par(N,[],L).

construir_par(1,L,L).
construir_par(N,Cop,L):-
    (
        (
            par(N),
            append([N],Cop,NewList),
            NewN is N-1,
            construir_par(NewN,NewList,L)
        );
        (
            NewN is N-1,
            construir_par(NewN,Cop,L)
        )
    ).

lista_impares(N,L):-
    construir_impar(N,[],L).

construir_impar(0,L,L).
construir_impar(N,Cop,L):-
    (
        (
            \+ par(N),
            append([N],Cop,NewList),
            NewN is N-1,
            construir_impar(NewN,NewList,L)
        );
        (
            NewN is N-1,
            construir_impar(NewN,Cop,L)
        )
    ).