:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(system)).

displayOutput(Input,0) :-
    write(' Solution: '), nl,prettyPrint(Input,0), nl.

displayOutput(Input,1) :-
    write(' Puzzle: '),nl, prettyPrint(Input,1,[],[2-2-2]), nl,
    write(' Solution: '), nl,prettyPrint(Input,0), nl.

prettyPrint([],_).
prettyPrint([L|Ls],0):-
    printRowSol(L),nl,
    prettyPrint(Ls,0).
prettyPrint([],_,_,_).
prettyPrint([L|Ls],1,ResList,NumColours):-
    printRowPuz(L,ResList,NList,NumColours,NNumColours),nl,
    prettyPrint(Ls,1,NList,NNumColours).

printRowSol([]).
printRowSol([E|R]):-
    write('('),write(E),write(')'),
    printRowSol(R).

printRowPuz([],L,L,N,N).
printRowPuz([E|R],ResList,NList,NumColours,NNumColours):-
    (
        \+ member(E, ResList),
        append(ResList,[E],NewList),
        write('('),write(' '),write(')'),
        printRowPuz(R,NewList,NList,NumColours,NNumColours)
    );
    (
        write('('),printColour(NumColours,NewNum),write(')'),
        printRowPuz(R,ResList,NList,NewNum,NNumColours)
    ).

printColour([R-G-Y],[NR-G-Y]):-
    write('R'),
    NR is R-1.
printColour([0-G-Y],[0-NG-Y]):-
    write('G'),
    NG is G-1.
printColour([0-0-Y],[0-0-NY]):-
    write('Y'),
    NY is Y-1.
/*
Input
    [   [red,yellow,yellow,green],
         [white,red,white],
          [green,white],
           [white]
    ]
    [   [A,B,B,C],
         [D,A,E],
          [C,F],
           [G]
    ]
    1:[[A,B,B,C],[D,A,E],[C,F],[G]]

    2:[[A,A,B,C,D],[B,E,F,G],[H,D,I],[J,K],[L]]
    3:[[A,B,C,C,D],[E,F,A,G],[H,I,J],[J,K],[L]]
    4:[[A,B,C,D,D],[E,F,B,G],[H,A,I],[J,K],[L]]

    5:[[A,B,B,C,C],[D,E,F,G],[H,I,J],[K,H],[L]]
    6:[[A,B,B,C,A],[D,E,F,G],[H,I,J],[J,K],[L]]
    7:[[A,B,B,C,D],[E,F,G,H],[D,A,I],[J,K],[L]]

    8:[[A,B,C,C,D],[E,A,F,G],[H,I,J],[K,H],[L]]
    9:[[A,B,C,A,D],[E,F,G,H],[I,D,J],[J,K],[L]]
    10:[[A,B,C,D,E],[F,G,E,H],[H,F,I],[J,K],[L]]

    11:[[A,B,B,C,D],[E,F,G,H],[I,E,J],[J,K],[L]]
    12:[[A,B,C,C,D],[E,F,G,B],[H,I,J],[K,E],[L]]
    13:[[A,B,C,C,D],[E,F,G,H],[H,E,I],[J,K],[L]]

    14:[[A,A,B,C,D,E],[F,G,H,I,J],[E,K,L,M],[N,M,O],[P,Q],[R]]
    15:[[A,B,C,A,D,B],[E,F,G,H,I],[J,K,L,M],[N,O,J],[P,Q],[R]]

    16:[[A,B,C,D,E,A],[F,G,H,F,I],[J,K,L,M],[M,N,O],[P,Q],[R]]
    17:[[A,B,C,D,E,F],[G,H,I,J,B],[K,L,G,M],[N,O,L],[P,Q],[R]]

Output
    [   [2,1,1,5],
         [3,2,6],
          [5,8],
           [13]
    ]

Domain

- First Row : 1-9
- Else: 2-...

Constraints

- Same color pieces have the same number, whites are all different
- Number below is the sum of top
*/
putColouredPieces(_,_,0,ColourNum,_,ColourNum).
putColouredPieces(SubL,N,ColouredPieces,ColourNum,ColourList,NCNum):-
    random(0,N,Position),
    nth0(Position,SubL,Element),
    random(0,3,Colour),
    putColour(Colour,ColourNum,ColourList,Element,NColourNum),
    CP is ColouredPieces-1,
    putColouredPieces(SubL,N,CP,NColourNum,ColourList,NCNum).

putColour(0,[RNum-GNum-YNum],[R,G,Y],Element,[NR-GNum-YNum]):-
    NR is RNum-1,
    Element=R.

putColour(0,[0-GNum-YNum],[R,G,Y],Element,[0-GNum-YNum]):-
    random(0,3,Colour),
    putColour(Colour,[0-GNum-YNum],[R,G,Y],Element,[0-GNum-YNum]).

putColour(1,[RNum-GNum-YNum],[R,G,Y],Element,[RNum-NG-YNum]):-
    NG is GNum-1,
    Element=G.

putColour(1,[RNum-0-YNum],[R,G,Y],Element,[RNum-0-YNum]):-
    random(0,3,Colour),
    putColour(Colour,[RNum-0-YNum],[R,G,Y],Element,[RNum-0-YNum]).

putColour(2,[RNum-GNum-YNum],[R,G,Y],Element,[RNum-GNum-NY]):-
    NY is YNum-1,
    Element=Y.

putColour(2,[RNum-GNum-0],[R,G,Y],Element,[RNum-GNum-0]):-
    random(0,3,Colour),
    putColour(Colour,[RNum-GNum-0],[R,G,Y],Element,[RNum-GNum-0]).

putColour(_,[0-0-0],_,_,_).

generateSubList(_,0, L, L,_,_).
generateSubList(Index,N,L,List,ColourNum,ColourList):-
    nth0(Index,L,SubL),
    length(SubL,N),
    random(1,3,ColouredPieces),
    putColouredPieces(SubL,N,ColouredPieces,ColourNum,ColourList,NCNum),
    NN is N-1, NIndex is Index+1,
    generateSubList(NIndex,NN,L,List,NCNum,ColourList).

generateList(N, L, List) :-
    length(L,N),
    generateSubList(0,N,L,List,[2-2-2],[R,G,Y]),
    List=L,!.

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

defineConstraints(List):-
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
    Cell #= First + Second,
    NIndex is Index+1,
    cellsum(NIndex, Row, RowLen, PrevRow).

grapegenerator(N,List) :-
    repeat,
    generateList(N, L, List),
    solver(List),
    displayOutput(List,1).

grapesolver(List) :-
    solver(List),
    displayOutput(List,0).

solver(Input) :-
    %Domain
    defineDomains(Input),
    
    %Restrictions
    term_variables(Input,FlatInput),
    all_distinct(FlatInput),
    defineConstraints(Input),

    %Labelling
    term_variables(Input,Output),
    labeling([], Output).

stop(N,List):-
    nth0(0,List,Row),
    nth0(0,Row,Num),
    Num=:=9,
    checkAllEqual(0,N,List).

checkAllEqual(N,N,_).
checkAllEqual(Index,N,List):-
    nth0(Index,List,Row),
    sort(Row,[_]),
    NIndex is Index+1,
    checkAllEqual(NIndex,N,List).