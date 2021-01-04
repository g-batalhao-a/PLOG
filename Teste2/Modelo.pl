:- use_module(library(lists)).

p1(L1,L2) :-
    gen(L1,L2),
    test(L2).

gen([],[]).
gen(L1,[X|L2]) :-
    select(X,L1,L3),
    gen(L3,L2).

test([_,_]).
test([X1,X2,X3|Xs]) :-
    (X1 < X2, X2 > X3; X1 > X2, X2 < X3),
    test([X2,X3|Xs]).

% lista Com números menores intercalados com números maiores ou vice-versa

% 2 - b

% 3
:- use_module(library(clpfd)).

p2(L1,L2) :-
    length(L1,N),
    length(L2,N),
    domain(L1,1,1000), domain(L2,1,1000),
    %
    pos(L1,L2,Is),
    all_distinct(Is),
    test(L2),
    %
    labeling([],Is).

pos([],_,[]).
pos([X|Xs],L2,[I|Is]) :-
    nth1(I,L2,X),
    pos(Xs,L2,Is).

% 4

receitas(NOvos,TempoMax,OvosPorReceita,TempoPorReceita,OvosUsados,Receitas):-
    length(OvosPorReceita,NumRecipes),
    Receitas=[R1,R2,R3,R4],
    domain(Receitas,1,NumRecipes),
    all_distinct(Receitas),
    element(R1,TempoPorReceita,X1),
    element(R2,TempoPorReceita,X2),
    element(R3,TempoPorReceita,X3),
    element(R4,TempoPorReceita,X4),
    Eggs#=<NOvos,
    eggs(Receitas,Eggs,OvosPorReceita),
    Sum #=X1+X2+X3+X4 #/\ Sum#=<TempoMax,
    OvosUsados=Eggs,
    !,
    labeling([maximize(Eggs)],Receitas).


eggs([],0,_).
eggs([A|E],Eggs,EggList):-
    element(A,EggList,Egg),
    Eggs #= Eggs2 + Egg,
    eggs(E,Eggs2,EggList).

%5

embrulha(Rolos,Presentes,RolosSelecionados):-
    length(Rolos,NumRolos),
    length(Presentes,NumPres),
    length(RolosSelecionados,NumPres),
    domain(RolosSelecionados,1,NumRolos),


    Eggs#=<NOvos,
    eggs(Receitas,Eggs,OvosPorReceita),
    Sum #=X1+X2+X3+X4 #/\ Sum#=<TempoMax,
    OvosUsados=Eggs,
    !,
    labeling([maximize(Eggs)],Receitas).