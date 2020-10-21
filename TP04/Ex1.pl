ligado(a,b). 
ligado(a,c). 
ligado(b,d). 
ligado(b,e). 
ligado(b,f). 
ligado(c,g).
ligado(d,h). 
ligado(d,i). 
ligado(f,i).
ligado(f,j).
ligado(f,k).
ligado(g,l).
ligado(g,m).
ligado(k,n).
ligado(l,o).
ligado(i,f).

membro(X,[X|_]):-!.
membro(X,[_|Y]):-membro(X,Y).

concatlist([],L,L).
concatlist([X|Y],L,[X|List]):-concatlist(Y,L,List).

invert([X],[X]).
invert([X|Y],List):-invert(Y,ListCop),concatlist(ListCop,[X],List).


find_all(X,Y,Z):- bagof(X, Y, Z),!.
find_all(_,_,[]).

children([N|R],[NChild,N|R]):-
    ligado(N,NChild),
    \+ membro(NChild,R).

prof(Path,NoFin,NoFin,[NoFin|Path]).
prof(Path,No,NoFin,Sol):-
    ligado(No,NoMed),
    \+ membro(NoMed,Path),
    prof([No|Path],NoMed,NoFin,Sol).

larg([[NoFin|T]|_],NoFin,[NoFin|T]).
larg([T|Fila],NoFin,Sol):-
    find_all(Children,children(T,Children),Child),
    concatlist(Fila,Child,FilaChild),
    larg(FilaChild,NoFin,Sol).

resolva_prof(NoInit,NoFin,Sol):-
    prof([],NoInit,NoFin,SolInv),
    invert(SolInv,Sol).

resolva_larg(NoInit,NoFin,Sol):-
    larg([[NoInit]],NoFin,SolInv),
    invert(SolInv,Sol).