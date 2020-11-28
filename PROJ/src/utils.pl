% Gets the list within a cell
% whether it is [black/white|...] or [empty]
getCellContent(SelColumn, SelRow, Content, GameState) :-
  nth0(SelRow, GameState, BoardRow),
  nth0(SelColumn, BoardRow, Content).

% Replace a single cell in a list-of-lists
replaceCell([L|Ls] , 0 , Y , Z , [R|Ls]) :- 
  replace_column(L,Y,Z,R).

replaceCell( [L|Ls] , X , Y , Z , [L|Rs] ) :-
  X > 0,
  X1 is X-1,
  replaceCell(Ls,X1,Y,Z,Rs).

replace_column([C|Cs],0,Z,[Ln|Cs]):-
  append(Z, C, Ln).
replace_column([C|Cs],Y,Z,[C|Rs]) :-
  Y > 0,
  Y1 is Y-1,
  replace_column(Cs, Y1, Z, Rs).


% Similar Function to replace Cell, but replaces the whole piece list with [empty]
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


% Function that iterates over a Matrix and returns the list of Moves
iterateMatrix(GameState, NumRows, NumCols, Player, PieceAndMoves):-
  iterateMatrix(GameState,GameState, 0, NumRows, 0, NumCols, Player,[],PieceAndMoves).

iterateMatrix(_,[], NumRows, NumRows, 0, _, _,PieceAndMoves,PieceAndMoves).
iterateMatrix(GameState, [R|Rs], NumRow, NumRows, 0, NumCols,Player,IntermedPiece,PieceAndMoves) :-
  findPiece(GameState, R, NumRow, 0, NumRows, NumCols, Player,FoundMovesPieces),
  append(IntermedPiece, FoundMovesPieces, NewPieceList),
  X is NumRow+1,
  iterateMatrix(GameState, Rs, X, NumRows, 0, NumCols, Player,NewPieceList,PieceAndMoves).
  
% Finds a Piece of a Player
findPiece(GameState, List, NumRow, NumCol, NumRows, NumCols, Player,FoundMovesPieces):-
  findPiece(GameState, List, NumRow, NumCol, NumRows, NumCols, Player,[],FoundMovesPieces).

findPiece(_, [], _, NumCols, NumRows, NumCols,_,FoundMovesPieces,FoundMovesPieces).
findPiece(GameState, [Head|Tail], NumRow, NumCol, NumRows, NumCols,Player,ValidPieceAndMove,FoundMovesPieces):-
  (
    verifyPlayer(Head, Player),
    checkNeighbours(GameState, NumRow, NumCol, NumRows, NumCols, CellPiecesAndMoves),
    append(ValidPieceAndMove, [CellPiecesAndMoves], NewPieceList),
    X is NumCol+1,
    findPiece(GameState, Tail, NumRow, X, NumRows, NumCols,Player,NewPieceList,FoundMovesPieces)
  );
  (
    X is NumCol+1,
    findPiece(GameState, Tail, NumRow, X, NumRows, NumCols,Player,ValidPieceAndMove,FoundMovesPieces)
  ).
  
% Checks for a non empty Cell nearby of a Piece
checkNeighbours(GameState,NumRow,NumCol, NumRows, NumCols,CellPiecesAndMoves) :-
  checkDown(GameState,NumRow,NumCol, NumRows, MoveDown,NumRow,NumCol), % Down
  checkUp(GameState,NumRow,NumCol, MoveUp,NumRow,NumCol), % Up
  checkRight(GameState,NumRow,NumCol, NumCols, MoveRight,NumRow,NumCol), % Right
  checkLeft(GameState,NumRow,NumCol, MoveLeft,NumRow,NumCol), % Left
  
  append([], MoveDown, L),
  append(L, MoveUp, L1),
  append(L1, MoveRight, L2),
  append(L2, MoveLeft, CellMoves),
  append([[NumCol,NumRow]], CellMoves, CellPiecesAndMoves).

% Checks Cells under the selected piece
% Doesn't check if the selected Piece is at the bottom Row
checkDown(GameState,NumRow,NumCol, NumRows, MoveDown, InitialRow, InitialCol):-
  NumRow \= NumRows - 1,
  NR is NumRow+1,
  nth0(NR, GameState, BoardRow),
  nth0(NumCol, BoardRow, Content),
  Content=[Head|_],
  (
    (
      Head\=empty,
      (
        Move = [[NumCol,NR]],
        append([], Move, MoveDown)
      )
    );
    checkDown(GameState,NR,NumCol, NumRows, MoveDown, InitialRow, InitialCol)
   
  ).
checkDown(_,_,_,_, [], _, _).

% Checks Cells over the selected piece
% Doesn't check if the selected Piece is at the top Row
checkUp(GameState,NumRow,NumCol, MoveUp, InitialRow, InitialCol):-
  NumRow \= 0,
  NR is NumRow-1,
  nth0(NR, GameState, BoardRow),
  nth0(NumCol, BoardRow, Content),
  Content=[Head|_],
  (
    (
      Head\=empty,
      (
        Move = [[NumCol,NR]],
        append([], Move, MoveUp)
      )
    );
    checkUp(GameState,NR,NumCol, MoveUp, InitialRow, InitialCol)
    
  ).
checkUp(_,_,_, [], _, _).

% Checks Cells to the right the selected piece
% Doesn't check if the selected Piece is at the rightest Column
checkRight(GameState,NumRow,NumCol, NumCols, MoveRight, InitialRow, InitialCol):-
  NumCol \= NumCols - 1,
  NC is NumCol+1,
  nth0(NumRow, GameState, BoardRow),
  nth0(NC, BoardRow, Content),
  Content=[Head|_],
  (
    (
      Head\=empty,
      (
        Move = [[NC,NumRow]],
        append([], Move, MoveRight)
      )
    );
    checkRight(GameState,NumRow,NC, NumCols, MoveRight, InitialRow, InitialCol)

  ).
checkRight(_,_,_,_, [], _, _).

% Checks Cells to the left of the selected piece
% Doesn't check if the selected Piece is at the leftest Column
checkLeft(GameState,NumRow,NumCol, MoveLeft, InitialRow, InitialCol):-
  NumCol \= 0,
  NC is NumCol-1,
  nth0(NumRow, GameState, BoardRow),
  nth0(NC, BoardRow, Content),
  Content=[Head|_],
  (
    (
      Head\=empty,
      (
        Move = [[NC,NumRow]],
        append([], Move, MoveLeft)
      )
    );
    checkLeft(GameState,NumRow,NC, MoveLeft, InitialRow, InitialCol)
    
  ).
checkLeft(_,_,_, [], _, _).