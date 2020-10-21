ligacao(1,2).
ligacao(1,3).
ligacao(2,4).
ligacao(3,4).
ligacao(3,6).
ligacao(4,6).
ligacao(5,6).

ligacao2(X,Y):-ligacao(X,Y).
ligacao2(X,Y):-ligacao(Y,X).

caminho(NoInicio,NoFim,Lista):-
    caminho(NoInicio,NoFim,[NoInicio],Lista,5).

caminho(NoInicio,NoFim,L,Lista,_):-
    ligacao2(NoInicio,NoFim),
    append(L,[NoFim],Lista).

caminho(NoInicio,NoFim,L,Lista,N):-
    N>0,
    ligacao2(NoInicio, NoMed),
    NoMed \= NoFim,
    \+(member(NoMed, L)),
    append(L, [NoMed], L2),
    N2 is N-1,
    caminho(NoMed, NoFim, L2, Lista, N2). 

ciclos(No, Comp, Lista):-
    findall(Ciclo, caminho(No, No, [], Ciclo, Comp), Lista). 
    