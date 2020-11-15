% Builds the 6x6 board
generate36Board(GameBoard):-
    buildBoard([],GameBoard,0,6,6,9,9,18). %buildBoard([],GameBoard,0,6,6,9,9,18)
% Builds the 6x9 board
generate54Board(GameBoard):-
    buildBoard([],GameBoard,0,6,9,18,18,18). %buildBoard([],GameBoard,0,6,6,18,18,18)
% Builds the 9x9 board
generate81Board(GameBoard):-
    buildBoard([],GameBoard,0,9,9,27,27,27). %buildBoard([],GameBoard,0,6,6,27,27,27)

buildBoard(FinalBoard,FinalBoard,NumRows,NumRows,_,0,0,0).
buildBoard(InitialBoard,FinalBoard,RowIndex,NumRows,NumCols,BP,WP,GP):-
    buildRow([],FinalRow,0,NumCols,BP,WP,GP,NBP,NWP,NGP),
    append(InitialBoard, FinalRow, UpdatedBoard),
    NewIndex is RowIndex+1,
    buildBoard(UpdatedBoard, FinalBoard, NewIndex, NumRows, NumCols,NBP,NWP,NGP).

buildRow(RowList,FinalRow,NumCols,NumCols,NBP,NWP,NGP,NBP,NWP,NGP):-FinalRow=[RowList].
buildRow(InitialRow,FinalRow,ColIndex,NumCols,BP,WP,GP,NBP,NWP,NGP):-
    random(0, 3, Piece),
    buildCell(Piece,Cell,BP,WP,GP,IBP,IWP,IGP),
    append(InitialRow, Cell, UpdatedRow),
    NewIndex is ColIndex+1,
    buildRow(UpdatedRow,FinalRow,NewIndex,NumCols,IBP,IWP,IGP,NBP,NWP,NGP).

% ADD WAY TO LIMIT PIECES, MAYBE PASS NUMBER OF PIECES IN THE START
% AND VERIFY HERE IF THERE ARE STILL AVAILABLE 
% buildCell(0,Cell,0,WP,GP):- random(0,3,Piece),buildCell(Piece,Cell,0,WP,GP)%
buildCell(0,Cell,0,WP,GP,IBP,IWP,IGP):-
    random(0, 3, Piece),
    buildCell(Piece,Cell,0,WP,GP,IBP,IWP,IGP).
buildCell(0,Cell,BP,WP,GP,IBP,IWP,IGP):-
    Cell=[[black]],
    IBP is BP-1, IWP=WP,IGP=GP.

buildCell(1,Cell,BP,0,GP,IBP,IWP,IGP):-
    random(0, 3, Piece),
    buildCell(Piece,Cell,BP,0,GP,IBP,IWP,IGP).
buildCell(1,Cell,BP,WP,GP,IBP,IWP,IGP):-
    Cell=[[white]],
    IWP is WP-1, IBP=BP,IGP=GP.

buildCell(2,Cell,BP,WP,0,IBP,IWP,IGP):-
    random(0, 3, Piece),
    buildCell(Piece,Cell,BP,WP,0,IBP,IWP,IGP).
buildCell(2,Cell,BP,WP,GP,IBP,IWP,IGP):-
    Cell=[[green]],
    IGP is GP-1, IBP=BP,IWP=WP.
%/*
initialBoard(GameBoard,0):-
    generate36Board(GameBoard).
%*/
%/*
initialBoard(GameBoard,1):-
    generate54Board(GameBoard).
%*/
%/*
initialBoard(GameBoard,2):-
    generate81Board(GameBoard).
%*/

/*
initialBoard(
[
[[white],[green],[green],[white],[green],[black]],
[[black],[green],[green],[green],[white],[white]],
[[green],[white],[white],[green],[black],[black]],
[[green],[black],[black],[green],[green],[green]],
[[black],[green],[green],[white],[black],[green]],
[[green],[white],[black],[green],[white],[green]]
]).
*/
%/*
medBoard([  
    [[empty],[empty],[black],[green],[black],[empty]],  
    [[empty],[empty],[empty],[empty],[empty],[empty]],  
    [[white],[green],[empty],[black],[empty],[empty]],  
    [[empty],[empty],[empty],[empty],[white],[black]],  
    [[empty],[black],[empty],[empty],[empty],[empty]],  
    [[empty],[empty],[empty],[empty],[white],[empty]]  
    ]).
%*/
/*
finalBoard([  
    [[empty],[empty],[empty],[black,white,green,green],[empty],[empty]],  
    [[empty],[empty],[empty],[empty],[empty],[empty]],  
    [[empty],[white,black,green],[empty],[empty],[black,green],[empty]],  
    [[empty],[empty],[empty],[empty],[empty],[empty]],  
    [[white,black,green,green],[empty],[empty],[black,green],[empty],[empty]],  
    [[empty],[empty],[empty],[empty],[empty],[white]]  
    ]).
*/
% Replaces values with symbols, for easier display
symbol(empty,' ').
symbol(black,'X').
symbol(white,'O').
symbol(green,'G').

% replaces Row Index with symbol, for easier selection
letter(0, 'A').
letter(1, 'B').
letter(2, 'C').
letter(3, 'D').
letter(4, 'E').
letter(5, 'F').
letter(6, 'G').
letter(7, 'H').
letter(8, 'I').

% Prints the Board
printBoard(X) :-
    nl,
    nth0(0, X, Row),
    length(Row, NumCols),
    length(X,NumRows),
    printHeader,
    printNumberHeader(0,NumCols),
    write('\n   '),
    printDivider(0,NumCols),
    printMatrix(X, 0,NumRows,NumCols).

% Prints a Matrix
printMatrix([], NumRows,NumRows,_).
printMatrix([Head|Tail], N,NumRows,NumCols) :-
    letter(N, L),
    write(' '),
    write(L),
    N1 is N + 1,
    write(' + '),
    printLine(Head),
    write('\n   '),
    printDivider(0,NumCols),
    printMatrix(Tail, N1,NumRows,NumCols).

% Prints a Line
printLine([]).
printLine([Head|Tail]) :-
    printCell(Head),
    write(' + '),
    printLine(Tail).

% Prints only the Head of a list
% Useful for only displaying the piece that is on top of a stack
printCell(L) :-
    L=[Head|_],
    symbol(Head, S),
    countPoints(L,Points),
    write(S),
    write('/'),
    write(Points).

%Prints the Board Number Header line
printNumberHeader(Cols,Cols).
printNumberHeader(Num,Cols):-
    write('     '), write(Num),
    X is Num+1,
    printNumberHeader(X,Cols).

% prints the divider
printDivider(Cols,Cols):-write('+\n').
printDivider(Num,Cols):-
    write('+-----'),
    X is Num+1,
    printDivider(X,Cols).
% Prints the header to eplain the contents of cell
printHeader:-
    write('Cell -> Top Piece/Points in Stack\n ').

% Prints Main Menu
printMainMenu:-
    write('\n\n _______________________________________________________________________ \n'),
    write('|                                                                       |\n'),
    write('|                                                                       |\n'),
    write('|             ___   ____   ____   ____   _  _   ____   ____             |\n'),
    write('|            / __) (  _ \\ ( ___) ( ___) ( \\( ) ( ___) (  _ \\            |\n'),
    write('|           ( (_-.  )   /  )__)   )__)   )  (   )__)   )   /            |\n'),
    write('|            \\___/ (_)\\_) (____) (____) (_)\\_) (____) (_)\\_)            |\n'),
    write('|                                                                       |\n'),
    write('|                          1. Player vs Player (6x6)                    |\n'),
    write('|                                                                       |\n'),
    write('|                          2. Player vs Player (6x9)                    |\n'),
    write('|                                                                       |\n'),
    write('|                          3. Player vs Player (9x9)                    |\n'),
    write('|                                                                       |\n'),
    write('|                          0. Exit                                      |\n'),
    write('|                                                                       |\n'),
    write('|                                                                       |\n'),
    write(' _______________________________________________________________________ \n').
    