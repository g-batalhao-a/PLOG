% Builds the 6x6 board

/*
initialBoard([
[[white],[green],[green],[white],[green],[black]],
[[black],[green],[green],[green],[white],[white]],
[[green],[white],[white],[green],[black],[black]],
[[green],[black],[black],[green],[green],[green]],
[[black],[green],[green],[white],[black],[green]],
[[green],[white],[black],[green],[white],[green]]
]).
*/
/*
medBoard([  
    [[empty],[empty],[black],[green],[black],[empty]],  
    [[empty],[empty],[empty],[empty],[empty],[empty]],  
    [[white],[green],[empty],[black],[empty],[empty]],  
    [[empty],[empty],[empty],[empty],[white],[black]],  
    [[empty],[black],[empty],[empty],[empty],[empty]],  
    [[empty],[empty],[empty],[empty],[white],[empty]]  
    ]).
*/
%/*
finalBoard([  
    [[empty],[empty],[empty],[black,white,green,green],[empty],[empty]],  
    [[empty],[empty],[empty],[empty],[empty],[empty]],  
    [[empty],[white,black,green],[empty],[empty],[black,green],[empty]],  
    [[empty],[empty],[empty],[empty],[empty],[empty]],  
    [[white,black,green,green],[empty],[empty],[black,green],[empty],[empty]],  
    [[empty],[empty],[empty],[empty],[empty],[white]]  
    ]).
%*/
% Replaces values with symbols, for easier display
symbol(empty,S) :- S=' '.
symbol(black,S) :- S='X'.
symbol(white,S) :- S='O'.
symbol(green,S) :- S='G'.

% replaces Row Index with symbol, for easier selection
letter(0, L) :- L='A'.
letter(1, L) :- L='B'.
letter(2, L) :- L='C'.
letter(3, L) :- L='D'.
letter(4, L) :- L='E'.
letter(5, L) :- L='F'.

% Prints the Board
printBoard(X) :-
    nl,
    write('   | 0 | 1 | 2 | 3 | 4 | 5 |\n'),
    write('---|---|---|---|---|---|---|\n'),
    printMatrix(X, 0).

% Prints a Matrix
printMatrix([], 6).
printMatrix([Head|Tail], N) :-
    letter(N, L),
    write(' '),
    write(L),
    N1 is N + 1,
    write(' | '),
    printLine(Head),
    write('\n---|---|---|---|---|---|---|\n'),
    printMatrix(Tail, N1).

% Prints a Line
printLine([]).
printLine([Head|Tail]) :-
    printCell(Head),
    write(' | '),
    printLine(Tail).

% Prints only the Head of a list
% Useful for only displaying the piece that is on top of a stack
printCell([Head|Tail]) :-
    symbol(Head, S),
    write(S).