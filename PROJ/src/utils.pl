% Gets the list within a cell
% whether it is ['black'/'white', ...] or ['empty']
getCellContent(SelColumn, SelRow, Content, GameState) :-
  nth0(SelRow, GameState, BoardRow),
  nth0(SelColumn, BoardRow, Content).
  %format('\nPiece: ~d ~d\nContent: ', [SelColumn, SelRow]),
  %write(Content),
  %nl.

% Replace a single cell in a list-of-lists
% the source list-of-lists is L
% The cell to be replaced is indicated with a row offset (X)
% and a column offset within the row (Y)
% The replacement value is Z
% the transformed list-of-lists (result) is R

replaceCell([L|Ls] , 0 , Y , Z , [R|Ls]) :- % once we find the desired row,
  replace_column(L,Y,Z,R).              % we replace specified column, and we're done.

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



% Similar Function to replace Cell, but replaces the whole piece list with ['empty']
replaceEmpty([L|Ls] , 0 , Y , Z , [R|Ls]) :-
  replace_columnempty(L,Y,Z,R).
replaceEmpty( [L|Ls] , X , Y , Z , [L|Rs] ) :-
  X > 0 ,                                 
  X1 is X-1 ,                             
  replaceEmpty( Ls , X1 , Y , Z , Rs ).    

replace_columnempty([_|Cs] , 0 , Z , [Z|Cs]).
replace_columnempty([C|Cs] , Y , Z , [C|Rs]) :- 
  Y > 0 ,                                  
  Y1 is Y-1 ,                              
  replace_columnempty( Cs , Y1 , Z , Rs ).      
  
% Function that sets flag Played to 0 if there is no possible move
% or 1 if a player has a possible move
iterateMatrix(GameState,GS, 0, 0, Player, ListOfMoves):-
  iterateMatrix(GameState,GS, 0, 0, Player, [], ListOfMoves).

iterateMatrix(GameState,[], 6, 0, Player, ListOfMoves,ListOfMoves).
iterateMatrix(GameState, [R|Rs],NumRow, 0, Player, IntermedList, ListOfMoves) :-
  findPiece(GameState, R, NumRow, 0, Player, FoundMoves),
  append(IntermedList, FoundMoves, NewList),
  X is NumRow+1,
  iterateMatrix(GameState, Rs, X, 0, Player, NewList, ListOfMoves).
  
% Finds a Piece of a Player
findPiece(GameState, List, NumRow, NumCol, Player, FoundMoves):-
  findPiece(GameState, List, NumRow, NumCol, Player, [], FoundMoves).

findPiece(GameState, [], _, 6, Player, FoundMoves, FoundMoves).
findPiece(GameState, [Head|Tail], NumRow, NumCol, Player, ValidMove, FoundMoves):-
  (
    verifyPlayer(Head, Player),
    checkNeighbours(GameState, NumRow, NumCol, CellMoves),
    append(ValidMove, CellMoves, NewList),
    X is NumCol+1,
    findPiece(GameState, Tail, NumRow, X, Player, NewList,FoundMoves)
  );
  (
    X is NumCol+1,
    findPiece(GameState, Tail, NumRow, X, Player, ValidMove, FoundMoves)
  ).
  
% Checks for a non empty Cell nearby of a Piece
checkNeighbours(GameState,NumRow,NumCol, CellMoves) :-
% Down

  checkDown(GameState,NumRow,NumCol, MoveDown)
  
  
,
% Up

  checkUp(GameState,NumRow,NumCol, MoveUp)
  
,
% Right

  checkRight(GameState,NumRow,NumCol, MoveRight)
  
,
% Left

  checkLeft(GameState,NumRow,NumCol, MoveLeft)
 
  ,
  append([], MoveDown, L),
  append(L, MoveUp, L1),
  append(L2, MoveRight, L3),
  append(L3, MoveLeft, CellMoves).


checkDown(GameState,NumRow,NumCol, MoveDown):-
  NumRow \= 5,
  NR is NumRow+1,
  nth0(NR, GameState, BoardRow),
  nth0(NumCol, BoardRow, Content),
  Content=[Head|_],
  Head\=empty,
  format('Piece: ~d ~d\n ', [NumCol, NumRow]),
  write('Found DOWN\n'),
  format('Piece: ~d ~d\n ', [NumCol, NR]),
  Move = [[NumCol,NR]],
  append([], Move, MoveDown).
checkDown(GameState,NumRow,NumCol, []).

checkUp(GameState,NumRow,NumCol, MoveUp):-
  NumRow \= 0,
  NR is NumRow-1,
  nth0(NR, GameState, BoardRow),
  nth0(NumCol, BoardRow, Content),
  Content=[Head|_],
  Head\=empty,
  format('Piece: ~d ~d\n ', [NumCol, NumRow]),
  write('Found UP\n'),
  format('Piece: ~d ~d\n ', [NumCol, NR]),
  Move = [[NumCol,NR]],
  append([], Move, MoveUp).
checkUp(GameState,NumRow,NumCol, []).

checkRight(GameState,NumRow,NumCol, MoveRight):-
  NumCol \= 5,
  NC is NumCol+1,
  nth0(NumRow, GameState, BoardRow),
  nth0(NC, BoardRow, Content),
  Content=[Head|_],
  Head\=empty,
  format('Piece: ~d ~d\n ', [NumCol, NumRow]),
  write('Found RIGHT\n'),
  format('Piece: ~d ~d\n ', [NC, NumRow]),
  Move = [[NC,NumRow]],
  append([], Move, MoveRight).
checkRight(GameState,NumRow,NumCol, []).


checkLeft(GameState,NumRow,NumCol, MoveLeft):-
  NumCol \= 0,
  NC is NumCol-1,
  nth0(NumRow, GameState, BoardRow),
  nth0(NC, BoardRow, Content),
  Content=[Head|_],
  Head\=empty,
  format('Piece: ~d ~d\n ', [NumCol, NumRow]),
  write('Found LEFT\n'),
  format('Piece: ~d ~d\n ', [NC, NumRow]),
  Move = [[NC,NumRow]],
  append([], Move, MoveLeft).

checkLeft(GameState,NumRow,NumCol, []).