% Selects a Piece from the Board and moves it
move(GameState, Player,FinalMoveGameState) :-
    readColumn(Column),
    validateColumn(Column,SelColumn),
    readRow(Row),
    validateRow(Row,SelRow),
    validateContent(SelColumn, SelRow, Player, GameState, Content, FinalMoveGameState),
    movePiece(GameState,Player,SelColumn,SelRow, Content,FinalMoveGameState).

% Moves a selected Piece to a newly selected Cell
movePiece(GameState,Player,SelColumn,SelRow, Content,FinalMoveGameState) :-
    write('\nMove to:\n'),
    readColumn(Column),
    validateColumn(Column,MoveColumn),
    validateColumnMove(MoveColumn, SelColumn, MovedCol, FinalCol),
    readRow(Row),
    validateRow(Row,MoveRow),
    validateRowMove(MoveRow, SelRow, MovedCol, FinalRow),
    validateCapture(FinalRow, FinalCol, SelRow, SelColumn, GameState, Player, Content, FinalMoveGameState).

% Reads Column Input
readColumn(Column) :-
    write('- Column '),
    read(Column).

%Reads Row Input
readRow(Row) :-
    write('- Row '),
    read(Row).

% Checks if user is selecting a column within boundaries
validateColumn(0, 0).
validateColumn(1, 1).
validateColumn(2, 2).
validateColumn(3, 3).
validateColumn(4, 4).
validateColumn(5, 5).
validateColumn(_Column, SelColumn) :-
    write('Invalid column\nSelect again'),
    readColumn(NewColumn),
    validateColumn(NewColumn, SelColumn).

% Checks if user is selecting a row within boundaries
validateRow('A', 0).
validateRow('B', 1).
validateRow('C', 2).
validateRow('D', 3).
validateRow('E', 4).
validateRow('F', 5).
validateRow(_Row, SelRow) :-
    write('Invalid row\nSelect again'),
    readRow(NewRow),
    validateRow(NewRow, SelRow).

% Checks if user is moving Piece to the same column or it's neighbouring ones
validateColumnMove(MoveColumn,SelColumn, MovedCol, FinalCol) :-
    MoveColumn=:=SelColumn, MovedCol = 0, FinalCol is MoveColumn;
    MoveColumn=:=SelColumn+1, MovedCol = 1, FinalCol is MoveColumn;
    MoveColumn=:=SelColumn-1, MovedCol = 1, FinalCol is MoveColumn;
    (
        write('Invalid Column Move\nSelect again\n'),
        readColumn(NewColumn),
        validateColumn(NewColumn, NewMoveColumn),
        validateColumnMove(NewMoveColumn, SelColumn, MovedCol, FinalCol)
    ).

% Checks if user is moving Piece to the same row, in case he hasn't selected the same column, or it's neighbouring ones
validateRowMove(MoveRow,SelRow, MovedCol, FinalRow) :-
    MoveRow=:=SelRow, MovedCol=:=1, FinalRow is MoveRow;
    MoveRow=:=SelRow+1, MovedCol=:=0, FinalRow is MoveRow;
    MoveRow=:=SelRow-1, MovedCol=:=0, FinalRow is MoveRow;
    (
        write('Invalid Row Move\nSelect again\n'),
        readRow(NewRow),
        validateRow(NewRow, NewMoveRow),
        validateRowMove(NewMoveRow, SelRow, MovedCol, FinalRow)
    ).