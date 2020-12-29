:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(system)).

displayOutput(Input,0) :-
    write(' Solution: '), nl,prettyPrint(Input,0), nl.

displayOutput(Input,1) :-
    getNonRepeatedNumbers(Input,NoRepeat,[],Repeat,[],3),
    write(' Puzzle: '),nl, prettyPrint(Input,1,NoRepeat,Repeat), nl,
    write(' Solution: '), nl,prettyPrint(Input,0), nl.

prettyPrint([],_).
prettyPrint([L|Ls],0):-
    printRowSol(L),nl,
    prettyPrint(Ls,0).
prettyPrint([],_,_,_).
prettyPrint([L|Ls],1,NoRepeat,Repeat):-
    printRowPuz(L,NoRepeat,Repeat),nl,
    prettyPrint(Ls,1,NoRepeat,Repeat).

printRowSol([]).
printRowSol([E|R]):-
    write('('),write(E),write(')'),
    printRowSol(R).

printRowPuz([],_,_).
printRowPuz([E|R],NoRepeat,Repeat):-
    (   
        \+member(E,NoRepeat),
        member(E-Colour,Repeat),
        write('('),write(Colour),write(')'),
        printRowPuz(R, NoRepeat, Repeat)
    );
    (
        write('( )'),
        printRowPuz(R,NoRepeat,Repeat)
    ).

getNonRepeatedNumbers([],NonRepeatList,NonRepeatList,RepeatList,RepeatList,0).
getNonRepeatedNumbers([R|Rest],NonRepeatList,Acc, RepeatList,RepAcc,NumColours):-
    iterateRow(R,Acc,NewAcc,RepAcc,NewReppAcc,NumColours,NColours),
    getNonRepeatedNumbers(Rest, NonRepeatList, NewAcc,RepeatList,NewReppAcc,NColours).

iterateRow([],NewAcc,NewAcc,RepAcc,RepAcc,NColours,NColours).
iterateRow([E|R],Acc,NewAcc,RepAcc,NewReppAcc,NumColours,NColours):-
    (
      \+member(E,Acc),
      append(Acc,[E],NAcc),
      iterateRow(R, NAcc, NewAcc,RepAcc,NewReppAcc,NumColours,NColours)
    );
    (     
        appendColour(NumColours,Colour,NColours2),
        append(RepAcc,[E-Colour],NRepAcc),
        delete(Acc, E, NAcc),
        iterateRow(R,NAcc,NewAcc,NRepAcc,NewReppAcc,NColours2,NColours)
    ).

appendColour(3,'R',2).
appendColour(2,'Y',1).
appendColour(1,'G',0).

/*
Input
    1:[[RED,YELLOW,YELLOW,GREEN],[D,RED,E],[GREEN,F],[G]]

    2:[[RED,RED,YELLOW,C,GREEN],[YELLOW,E,F,G],[H,GREEN,I],[J,K],[L]]
    3:[[RED,B,YELLOW,YELLOW,D],[E,F,RED,G],[H,I,GREEN],[GREEN,K],[L]]
    4:[[RED,YELLOW,C,GREEN,GREEN],[E,F,YELLOW,G],[H,RED,I],[J,K],[L]]

    5:[[A,RED,RED,YELLOW,YELLOW],[D,E,F,G],[GREEN,I,J],[K,GREEN],[L]]
    6:[[RED,YELLOW,YELLOW,C,RED],[D,E,F,G],[H,I,GREEN],[GREEN,K],[L]]
    7:[[RED,YELLOW,YELLOW,C,GREEN],[E,F,G,H],[GREEN,RED,I],[J,K],[L]]

    8:[[RED,B,YELLOW,YELLOW,D],[E,RED,F,G],[GREEN,I,J],[K,GREEN],[L]]
    9:[[RED,B,C,RED,YELLOW],[E,F,G,H],[I,YELLOW,GREEN],[GREEN,K],[L]]
    10:[[A,B,C,D,RED],[YELLOW,G,RED,GREEN],[GREEN,YELLOW,I],[J,K],[L]]

    11:[[A,RED,RED,C,D],[YELLOW,F,G,H],[I,YELLOW,GREEN],[GREEN,K],[L]]
    12:[[A,RED,YELLOW,YELLOW,D],[GREEN,F,G,RED],[H,I,J],[K,GREEN],[L]]
    13:[[A,B,RED,RED,D],[YELLOW,F,G,GREEN],[GREEN,YELLOW,I],[J,K],[L]]

    14:[[RED,RED,B,C,D,YELLOW],[F,G,H,I,J],[YELLOW,K,L,GREEN],[N,GREEN,O],[P,Q],[R]]
    15:[[RED,YELLOW,C,RED,D,YELLOW],[E,F,G,H,I],[GREEN,K,L,M],[N,O,GREEN],[P,Q],[R]]

    16:[[RED,B,C,D,E,RED],[YELLOW,G,H,YELLOW,I],[J,K,L,GREEN],[GREEN,N,O],[P,Q],[R]]
    17:[[A,RED,C,D,E,F],[YELLOW,H,I,J,RED],[K,GREEN,YELLOW,M],[N,O,GREEN],[P,Q],[R]]


Domain

- First Row : 1-9
- Else: 2-...

Constraints

- Same color pieces have the same number, whites are all different
- Number below is the sum of top
*/

defineDomains(List):-
    nth0(0,List,FirstRow),
    domain(FirstRow,1,9),
    length(List, NumRows),
    defineDomainRest(1,List,NumRows).

defineDomainRest(NumRows,_,NumRows).
defineDomainRest(Index,List,NumRows):-
    nth0(Index,List,Row),
    domain(Row,2,1000),
    NIndex is Index+1,
    defineDomainRest(NIndex,List,NumRows).

defineSumConstraints(List):-
    length(List, NumRows),
    sumBuilder(1,List,NumRows).

sumBuilder(NumRows,_,NumRows).
sumBuilder(Index,List,NumRows):-
    PrevIndex is Index-1,
    nth0(PrevIndex,List,PrevRow),
    nth0(Index,List,Row),
    length(Row,RowLen),
    cellsum(0,Row,RowLen,PrevRow),
    NIndex is Index+1,
    sumBuilder(NIndex, List, NumRows).

cellsum(RowLen,_,RowLen,_).
cellsum(Index,Row,RowLen,PrevRow):-
    nth0(Index,PrevRow,First),
    PrevRowI is Index+1,
    nth0(PrevRowI,PrevRow,Second),
    nth0(Index,Row,Cell),
    sum([First,Second],#=,Cell),
    NIndex is Index+1,
    cellsum(NIndex, Row, RowLen, PrevRow).

grapegenerator(N,List) :-
    solver(N,List).
    %displayOutput(List,1). Retirar este comentário para ter todas as soluções

grapesolver(List) :-
    length(List,N),
    solver(N,List).
    %displayOutput(List,0).

getSubList(_,0,_).
getSubList(Input,N,It):-
    nth0(It, Input, SubL),
    length(SubL,N),
    NewN is N-1, NewIt is It+1,
    getSubList(Input,NewN,NewIt).

solver(N,Input) :-
    statistics(walltime, [Start,_]),

    length(Input,N),
    getSubList(Input,N,0),
    buildNumberList(TempList),
    %Domain
    defineDomains(Input),
    
    %Restrictions
    append(Input,FlatInput),
    global_cardinality(FlatInput,TempList),
    parseCountList(TempList,CountList,[]),
    (
        ( N < 4, Colours is N-1  );
        ( N < 7, Colours is 3)
    ),
    global_cardinality(CountList,[0-_,1-_,2-Colours]),
    defineSumConstraints(Input),
   
    !,
    %Labelling
    term_variables(Input,Output),
    labeling([], Output),
    %labeling([variable(selRandom)], Output).
    statistics(walltime, [End,_]),
	Time is End - Start,
    format('\nDuration: ~3d s~n\n', [Time]).

buildNumberList(NumList):-
    length(NumList,256),
    iterate(NumList,1,256).

iterate([],Index,Max):- Index is Max+1.
iterate([E|R],Index,Max):-
    E=Index-_,
    NewIndex is Index+1,
    iterate(R,NewIndex,Max).

parseCountList([],Result,Result).
parseCountList([_-Num|R],Result,Acc):-
    append(Acc,[Num],NewAcc),
    parseCountList(R, Result, NewAcc).


selRandom(ListOfVars, Var, Rest) :-
    random_select(Var, ListOfVars, Rest).
    