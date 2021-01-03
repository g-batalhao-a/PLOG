:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(system)).

:- consult('test.pl').

% Displays only the Solution, used in grapesolver
displayOutput(Input) :-
    write(' Solution: '), nl,prettyPrint(Input), nl.

% Displays both Problem and the Solution to that problem, used in grapegenerator
displayOutput(Input,Colours) :-
    getNonRepeatedNumbers(Input,NoRepeat,[],Repeat,[],Colours),
    write(' Puzzle: '),nl, prettyPrint(Input,NoRepeat,Repeat), nl,
    write(' Solution: '), nl,prettyPrint(Input), nl,!.

% Displays the variable list in a simple List View
simpleDisplay(Input) :-
    write(Input), nl.

% Calls the predicate to print the solution's rows
prettyPrint([]).
prettyPrint([L|Ls]):-
    printRowSol(L),nl,
    prettyPrint(Ls).

% Calls the predicate to print the puzzle's rows
prettyPrint([],_,_).
prettyPrint([L|Ls],NoRepeat,Repeat):-
    printRowPuz(L,NoRepeat,Repeat),nl,
    prettyPrint(Ls,NoRepeat,Repeat).

% Prints the numbers in a row
printRowSol([]).
printRowSol([E|R]):-
    write('('),write(E),write(')'),
    printRowSol(R).

% Prints a letter for a repeated number or a blank space for non repeated numbers
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

% Obtains the Repeated and Non Repeated Numbers from the Result
getNonRepeatedNumbers([],NonRepeatList,NonRepeatList,RepeatList,RepeatList,0).
getNonRepeatedNumbers([R|Rest],NonRepeatList,Acc, RepeatList,RepAcc,NumColours):-
    iterateRow(R,Acc,NewAcc,RepAcc,NewReppAcc,NumColours,NColours),
    getNonRepeatedNumbers(Rest, NonRepeatList, NewAcc,RepeatList,NewReppAcc,NColours).

% Iterates through a row and assigns both the repeated and non repeated numbers to their respective lists
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

% Appends a colour to a repeated number
appendColour(10,'J',9).
appendColour(9,'I',8).
appendColour(8,'H',7).
appendColour(7,'G',6).
appendColour(6,'F',5).
appendColour(5,'E',4).
appendColour(4,'D',3).
appendColour(3,'C',2).
appendColour(2,'B',1).
appendColour(1,'A',0).

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

    18:[[RED,RED,GREEN,BLUE,PINK,PINK,A],[GREEN,BLUE,YELLOW,B,VIOLET,C],[YELLOW,VIOLET,D,E,F],[G,H,I,J],[K,L,M],[M,N],[O]]

Domain

- First Row : 1-9
- Else: 2-...

Constraints

- Same color pieces have the same number, whites are all different
- Number below is the sum of top
- Must have X repeated numbers (number of colours) -> flexible restriction
*/

% Defines the domain for the first row and calls the predicate to assign the domain to the next rows
defineDomains(List):-
    nth0(0,List,FirstRow),
    domain(FirstRow,1,9),
    length(List, NumRows),
    defineDomainRest(1,List,NumRows).

% Defines de domain for all rows (except the first)
defineDomainRest(NumRows,_,NumRows).
defineDomainRest(Index,List,NumRows):-
    nth0(Index,List,Row),
    defineUpperBound(NumRows,UpperBound),
    domain(Row,2,UpperBound),
    NIndex is Index+1,
    defineDomainRest(NIndex,List,NumRows).

% Defines the max value that can appear in a puzzle, given its rows
defineUpperBound(2,18).
defineUpperBound(3,35).
defineUpperBound(4,68).
defineUpperBound(5,132).
defineUpperBound(6,256).
defineUpperBound(7,496).
defineUpperBound(8,960).
defineUpperBound(9,1856).
defineUpperBound(10,3584).

% Applies the sum constraint to the list
defineSumConstraints(List):-
    length(List, NumRows),
    sumBuilder(1,List,NumRows).

% Iterates through a row and applies the sum restriction
sumBuilder(NumRows,_,NumRows).
sumBuilder(Index,List,NumRows):-
    PrevIndex is Index-1,
    nth0(PrevIndex,List,PrevRow),
    nth0(Index,List,Row),
    length(Row,RowLen),
    cellsum(0,Row,RowLen,PrevRow),
    NIndex is Index+1,
    sumBuilder(NIndex, List, NumRows).

% Applies the sum restriction => FatherLeft + FatherRight = Cell
cellsum(RowLen,_,RowLen,_).
cellsum(Index,Row,RowLen,PrevRow):-
    nth0(Index,PrevRow,First),
    PrevRowI is Index+1,
    nth0(PrevRowI,PrevRow,Second),
    nth0(Index,Row,Cell),
    sum([First,Second],#=,Cell),
    NIndex is Index+1,
    cellsum(NIndex, Row, RowLen, PrevRow).


% Testing Predicates
testsolver1:-
    grapesolver([[RED,YELLOW,YELLOW,GREEN],[D,RED,E],[GREEN,F],[G]]).
testsolver2:-
    grapesolver([[RED,B,YELLOW,YELLOW,D],[E,RED,F,G],[GREEN,I,J],[K,GREEN],[L]]).
testsolver3:-
    grapesolver([[A,RED,C,D,E,F],[YELLOW,H,I,J,RED],[K,GREEN,YELLOW,M],[N,O,GREEN],[P,Q],[R]]).
testgenerator1:-
    grapegenerator(4,L).
testgenerator2:-
    grapegenerator(5,L).
testgenerator3:-
    grapegenerator(6,L).

% Generates a puzzle
grapegenerator(N,List) :-
    solver(N,List,Colours),
    displayOutput(List,Colours).

% Solves a puzzle
grapesolver(List) :-
    solver(N,List,_),
    displayOutput(List).

% Verifies/Creates a sublist (depends if the Input is a List of Lists already or only a List)
getSubList(_,0,_).
getSubList(Input,N,It):-
    nth0(It, Input, SubL),
    length(SubL,N),
    NewN is N-1, NewIt is It+1,
    getSubList(Input,NewN,NewIt).

% Solver of the problem
solver(N,Input,Colours) :-
    %Verifies/Creates a List with size N (depends if Input is alread a List or a variable)
    length(Input,N),
    getSubList(Input,N,0),
    buildNumberList(TempList,N),
    %Domain
    defineDomains(Input),
    
    %Restrictions
    append(Input,FlatInput),

    % Counts the occurrences of numbers in the list
    global_cardinality(FlatInput,TempList),
    parseCountList(TempList,CountList,[]),
    % Assigns a required number of colours to the problem
    % The original problem only had from 4 to 6 rows, these have no more than one solution
    % Problems below 4 or above 6 rows may contain multiple solutions, since the relation rows-colours was arbitrary
    (
        ( N < 4, Colours is N-1  );
        ( N < 7, Colours is 3);
        ( Colours is N-1)
    ),
    % Applies the restriction that only N amount of numbers may repeated and only in pairs
    global_cardinality(CountList,[0-_,1-_,2-Colours]),
    defineSumConstraints(Input),
   
    !,
    %Labelling
    term_variables(Input,Output),
    labeling([ffc,enum,up], Output).
    %simpleDisplay(Input). % This line was used for saving results in files

% Solver that allows for different labeling, used for experiments
% Identical to the above, except for labeling options
solver(N,Input,X,Y,Z) :-
    length(Input,N),
    getSubList(Input,N,0),
    buildNumberList(TempList,N),
    %Domain
    defineDomains(Input),
    
    %Restrictions
    append(Input,FlatInput),
    global_cardinality(FlatInput,TempList),
    parseCountList(TempList,CountList,[]),
    (
        ( N < 4, Colours is N-1  );
        ( N < 7, Colours is 3);
        ( Colours is N-1)
    ),
    global_cardinality(CountList,[0-_,1-_,2-Colours]),
    defineSumConstraints(Input),
    
    !,
    %Labelling
    term_variables(Input,Output),
    labeling([X,Y,Z], Output).
    %simpleDisplay(Input).

% Builds the list of Number-NumberOfOccurrences 
% (NumberOfOccurences is the times a number appears in the result, it is not instantiated when creating the list)
buildNumberList(NumList,N):-
    defineUpperBound(N,UpperBound),
    length(NumList,UpperBound),
    iterate(NumList,1,UpperBound).

% Itetates through the number list
iterate([],Index,Max):- Index is Max+1.
iterate([E|R],Index,Max):-
    E=Index-_,
    NewIndex is Index+1,
    iterate(R,NewIndex,Max).

% Parses a list of type Number-NumberOfOccurrences to NumberOfOccurrences 
parseCountList([],Result,Result).
parseCountList([_-Num|R],Result,Acc):-
    append(Acc,[Num],NewAcc),
    parseCountList(R, Result, NewAcc).

%labeling( [ variable(selRandom) ], Vars).
% seleciona uma variável de forma aleatória
selRandom(ListOfVars, Var, Rest):-
    random_select(Var, ListOfVars, Rest), % da library(random)
    (\+ number(Var));(selRandom(ListOfVars, Var, Rest)).
    