:-use_module(library(clpfd)).
% 1 - Gen&Test
% 2 - instanciado antes e restriçoes

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

cut(Shelves, Boards, SelectedBoards) :-
    length(Shelves, NShelves),
    length(Boards, NBoards),
    length(SelectedBoards, NShelves),

    domain(SelectedBoards, 1, NBoards),

    getUsedBoards(Shelves, SelectedBoards, UsedBoards, NBoards),
    constraintBoards(UsedBoards, Boards), 

    labeling([], SelectedBoards).


constraintBoards([], []).
constraintBoards([UsedBoard | UsedRest], [Board | Rest]) :-
    UsedBoard #=< Board,
    constraintBoards(UsedRest, Rest).


getUsedBoards(Shelves, SelectedBoards, UsedBoards, NBoards) :-
    length(BoardsAcc, NBoards),
    maplist(=(0), BoardsAcc),
    getTotalUsed(Shelves, SelectedBoards, BoardsAcc, UsedBoards).


getTotalUsed([], [], UsedBoards, UsedBoards).
getTotalUsed([Shelf | RestShelves], [Selected | Rest], Acc, UsedBoards) :-
    element(Selected, Acc, OldValue),
    NewValue #= OldValue + Shelf,
    copyListWithNewValue(Acc, NewAcc, Selected, NewValue),
    getTotalUsed(RestShelves, Rest, NewAcc, UsedBoards).



copyListWithNewValue([], [], _, _).
copyListWithNewValue([E1 | L1], [E2 | L2], NewValueIndex, NewValue) :-
    (NewValueIndex #= 1 #/\ E2 #= NewValue) #\/ (NewValueIndex #\= 1 #/\ E2 #= E1),
    N1 #= NewValueIndex - 1,
    copyListWithNewValue(L1, L2, N1, NewValue).