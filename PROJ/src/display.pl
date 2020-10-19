initialBoard([
[[white],[green],[green],[white],[green],[black]],
[[black],[green],[green],[green],[white],[white]],
[[green],[white],[white],[green],[black],[black]],
[[green],[black],[black],[green],[green],[green]],
[[black],[green],[green],[white],[black],[green]],
[[green],[white],[black],[green],[white],[green]]
]).

value(green,1).
value(_,0).

symbol(empty,S) :- S='.'.
symbol(black,S) :- S='X'.
symbol(white,S) :- S='O'.
symbol(green,S) :- S='G'.

letter(0, L) :- L='A'.
letter(1, L) :- L='B'.
letter(2, L) :- L='C'.
letter(3, L) :- L='D'.
letter(4, L) :- L='E'.
letter(5, L) :- L='F'.

printBoard(X) :-
    nl,
    write('   | 0 | 1 | 2 | 3 | 4 | 5 |\n'),
    write('---|---|---|---|---|---|---|\n'),
    printMatrix(X, 0).

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

printLine([]).

printLine([Head|Tail]) :-
    printCell(Head),
    write(' | '),
    printLine(Tail).

printCell([Head|Tail]) :-
    symbol(Head, S),
    write(S).