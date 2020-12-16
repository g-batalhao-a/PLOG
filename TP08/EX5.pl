initial(0-0).
final(2-_Y).

ligado(e1,_X-Y,0-Y).
ligado(e2,X-_Y,X-0).

ligado(f1,_X-_Y,4-_Y).
ligado(f2,_X-_Y,_X-3).

ligado(f1t2,_X-_Y,X1-Y1):-
    .

b :- initial(Ini),final(Final),dfs(Ini,Final,[Ini],Path),write(Path).
minB:- initial(Ini),final(Final),setof(Len-Path,(dfs(Ini,Final,[Ini],Path),length(Path,Len)),[MinLen-MinPath|_]),write(MinPath).

membro(X,[X|_]):-!.
membro(X,[_|Y]):-membro(X,Y).

dfs(Path,NoFin,NoFin,[NoFin|Path]).
dfs(Path,No,NoFin,Sol):-
    ligado(No,NoMed),
    \+ member(NoMed,Path),
    prof([No|Path],NoMed,NoFin,Sol).