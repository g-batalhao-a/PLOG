getCellContent(SelColumn, SelRow, Content, GameState) :-
    nth0(SelRow, GameState, BoardRow),
    nth0(SelColumn, BoardRow, Content),
    format('\nPiece: ~d ~d\nContent: ', [SelColumn, SelRow]),
    write(Content),
    nl.

% replace a single cell in a list-of-lists
% - the source list-of-lists is L
% - The cell to be replaced is indicated with a row offset (X)
%   and a column offset within the row (Y)
% - The replacement value is Z
% - the transformed list-of-lists (result) is R

replaceCell([L|Ls] , 0 , Y , Z , [R|Ls]) :- % once we find the desired row,
  replace_column(L,Y,Z,R).              % - we replace specified column, and we're done.

replaceCell( [L|Ls] , X , Y , Z , [L|Rs] ) :- % if we haven't found the desired row yet
  X > 0 ,                                 % and the row offset is positive,
  X1 is X-1 ,                             % we decrement the row offset
  replaceCell( Ls , X1 , Y , Z , Rs ).    % and recurse down

replace_column([C|Cs] , 0 , Z , [Ln|Cs]):-  % once we find the specified offset, just make the substitution and finish up.
  append(Z, C, Ln).
replace_column([C|Cs] , Y , Z , [C|Rs]) :- % otherwise,
  Y > 0 ,                                  % assuming that the column offset is positive,
  Y1 is Y-1 ,                              % we decrement it
  replace_column( Cs , Y1 , Z , Rs ).      % and recurse down.


% (NumRow e NumCol começa com 0)
iterateMatrix(GameState,[], 5, 5, Player, Played):-
  Played = 0.

iterateMatrix(GameState, [R|Rs],NumRow, NumCol, Player, Played) :-
  findPiece(GameState, R, NumRow, NumCol, Player, Played),
  (
    Played == 1;
    X is NumRow+1,
    iterateMatrix(GameState, Rs, X, NumCol, Player, Played)
  ).
  

findPiece(GameState, [], NumRow, 5, Player, Played).

findPiece(GameState, [Head|Tail], NumRow, NumCol, Player, Played):-
  (
    verifyPlayer(Head, Player),
    checkNeighbours(GameState, NumRow, NumCol, Played)
  );
  (
    Played == 1;
    X is NumCol+1,
    findPiece(GameState, L, NumRow, X, Player, Played)
  ).
  

checkNeighbours(GameState,NumRow,NumCol, Played) :-
  (
    (
      % Down
      (
        NumRow \= 5,
        NR is NumRow+1,
        nth0(NR, GameState, BoardRow),
        nth0(NumCol, BoardRow, Content),
        Content=[Head|_],
        Head\='empty'
      );
      % Up
      ( 
        NumRow \= 0,
        NR is NumRow-1,
        nth0(NR, GameState, BoardRow),
        nth0(NumCol, BoardRow, Content),
        Content=[Head|_],
        Head\='empty'
      );
      % Right
      (
        NumCol \= 5,
        NC is NumCol+1,
        nth0(NumRow, GameState, BoardRow),
        nth0(NC, BoardRow, Content),
        Content=[Head|_],
        Head\='empty'
      );
      % Left
      (
        NumCol \= 0,
        NC is NumCol-1,
        nth0(NumRow, GameState, BoardRow),
        nth0(NC, BoardRow, Content),
        Content=[Head|_],
        Head\='empty'
      )
    ),
    Played = 1
  ).