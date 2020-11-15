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
  
% Function that iterates over a Matrix
iterateMatrix(GameState, NumRows, NumCols, Player, ListOfMoves,PieceAndMoves):-
  iterateMatrix(GameState,GameState, 0, NumRows, 0, NumCols, Player, [], ListOfMoves,[],PieceAndMoves).

iterateMatrix(_,[], NumRows, NumRows, 0, _, _, ListOfMoves,ListOfMoves,PieceAndMoves,PieceAndMoves).
iterateMatrix(GameState, [R|Rs], NumRow, NumRows, 0, NumCols,Player, IntermedList, ListOfMoves,IntermedPiece,PieceAndMoves) :-
  findPiece(GameState, R, NumRow, 0, NumCols, Player, FoundMoves,FoundMovesPieces),
  append(IntermedList, FoundMoves, NewList),
  append(IntermedPiece, FoundMovesPieces, NewPieceList),
  X is NumRow+1,
  iterateMatrix(GameState, Rs, X, NumRows, 0, NumCols, Player, NewList, ListOfMoves,NewPieceList,PieceAndMoves).
  
% Finds a Piece of a Player
findPiece(GameState, List, NumRow, NumCol, NumCols, Player, FoundMoves,FoundMovesPieces):-
  findPiece(GameState, List, NumRow, NumCol, NumCols, Player, [], FoundMoves,[],FoundMovesPieces).

findPiece(_, [], _, NumCols, NumCols,_, FoundMoves, FoundMoves,FoundMovesPieces,FoundMovesPieces).
findPiece(GameState, [Head|Tail], NumRow, NumCol, NumCols,Player, ValidMove, FoundMoves,ValidPieceAndMove,FoundMovesPieces):-
  (
    verifyPlayer(Head, Player),
    checkNeighbours(GameState, NumRow, NumCol, CellMoves,CellPiecesAndMoves),
    append(ValidMove, [CellMoves], NewList),
    append(ValidPieceAndMove, [CellPiecesAndMoves], NewPieceList),
    X is NumCol+1,
    findPiece(GameState, Tail, NumRow, X, NumCols,Player, NewList,FoundMoves,NewPieceList,FoundMovesPieces)
  );
  (
    append(ValidMove, [], NewList),
    append(ValidPieceAndMove, [], NewPieceList),
    X is NumCol+1,
    findPiece(GameState, Tail, NumRow, X, NumCols,Player, NewList, FoundMoves,NewPieceList,FoundMovesPieces)
  ).
  
% Checks for a non empty Cell nearby of a Piece
checkNeighbours(GameState,NumRow,NumCol, CellMoves,CellPiecesAndMoves) :-
% Down

  checkDown(GameState,NumRow,NumCol, MoveDown,NumRow,NumCol)
  
,
% Up

  checkUp(GameState,NumRow,NumCol, MoveUp,NumRow,NumCol)
,
% Right

  checkRight(GameState,NumRow,NumCol, MoveRight,NumRow,NumCol)
  
,
% Left

  checkLeft(GameState,NumRow,NumCol, MoveLeft,NumRow,NumCol)
 
  ,
  append([], MoveDown, L),
  append(L, MoveUp, L1),
  append(L1, MoveRight, L2),
  append(L2, MoveLeft, CellMoves),
  append([[NumCol,NumRow]], CellMoves, CellPiecesAndMoves).


checkDown(GameState,NumRow,NumCol, MoveDown, InitialRow, InitialCol):-
  NumRow \= 5,
  NR is NumRow+1,
  nth0(NR, GameState, BoardRow),
  nth0(NumCol, BoardRow, Content),
  Content=[Head|_],
  (
    (
      Head\=empty,
      (
        /*
        format('Piece: ~d ~d  ', [InitialCol, InitialRow]),
        write('Found DOWN '),
        format('Piece: ~d ~d\n ', [NumCol, NR]),%*/
        Move = [[NumCol,NR]],
        append([], Move, MoveDown)
        )
    );
    checkDown(GameState,NR,NumCol, MoveDown, InitialRow, InitialCol)
   
  ).
checkDown(_,_,_, [], _, _).

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
        /*
        format('Piece: ~d ~d ', [InitialCol, InitialRow]),
        write('Found UP '),
        format('Piece: ~d ~d\n ', [NumCol, NR]),%*/
        Move = [[NumCol,NR]],
        append([], Move, MoveUp)
      )
    );
    checkUp(GameState,NR,NumCol, MoveUp, InitialRow, InitialCol)
    
  ).
checkUp(_,_,_, [], _, _).

checkRight(GameState,NumRow,NumCol, MoveRight, InitialRow, InitialCol):-
  NumCol \= 5,
  NC is NumCol+1,
  nth0(NumRow, GameState, BoardRow),
  nth0(NC, BoardRow, Content),
  Content=[Head|_],
  (
    (
      Head\=empty,
      (
        /*
        format('Piece: ~d ~d ', [InitialCol, InitialRow]),
        write('Found RIGHT '),
        format('Piece: ~d ~d\n ', [NC, NumRow]),%*/
        Move = [[NC,NumRow]],
        append([], Move, MoveRight)
      )
    );
    checkRight(GameState,NumRow,NC, MoveRight, InitialRow, InitialCol)

  ).
checkRight(_,_,_, [], _, _).


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
        /*
        format('Piece: ~d ~d ', [InitialCol, InitialRow]),
        write('Found LEFT '),
        format('Piece: ~d ~d\n ', [NC, NumRow]),%*/
        Move = [[NC,NumRow]],
        append([], Move, MoveLeft)
      )
    );
    checkLeft(GameState,NumRow,NC, MoveLeft, InitialRow, InitialCol)
    
  ).

checkLeft(_,_,_, [], _, _).