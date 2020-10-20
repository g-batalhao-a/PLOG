selectPiece(GameState, Player,FinalMoveGameState) :-
    readColumn(Column),
    validateColumn(Column,SelColumn),
    readRow(Row),
    validateRow(Row,SelRow),
    validateContent(SelColumn, SelRow, Player, GameState, Content, FinalMoveGameState),
    movePiece(GameState,Player,SelColumn,SelRow, Content,FinalMoveGameState).

movePiece(GameState,Player,SelColumn,SelRow, Content,FinalMoveGameState) :-
    write('\nMove to:\n'),
    readColumn(Column),
    validateColumn(Column,MoveColumn),
    validateColumnMove(MoveColumn, SelColumn, MovedCol, FinalCol),
    readRow(Row),
    validateRow(Row,MoveRow),
    validateRowMove(MoveRow, SelRow, MovedCol, FinalRow),
    validateCapture(FinalRow, FinalCol, SelRow, SelColumn, GameState, Player, Content, FinalMoveGameState).

readColumn(Column) :-
    write('- Column '),
    read(Column).

readRow(Row) :-
    write('- Row '),
    read(Row).

validateColumn(0, SelColumn) :-
    SelColumn=0.
validateColumn(1, SelColumn) :-
    SelColumn=1.
validateColumn(2, SelColumn) :-
    SelColumn=2.
validateColumn(3, SelColumn) :-
    SelColumn=3.
validateColumn(4, SelColumn) :-
    SelColumn=4.
validateColumn(5, SelColumn) :-
    SelColumn=5.
validateColumn(_Column, SelColumn) :-
    write('Invalid column\nSelect again'),
    readColumn(NewColumn),
    validateColumn(NewColumn, SelColumn).

validateRow('A', SelRow) :-
    SelRow=0.
validateRow('B', SelRow) :-
    SelRow=1.
validateRow('C', SelRow) :-
    SelRow=2.
validateRow('D', SelRow) :-
    SelRow=3.
validateRow('E', SelRow) :-
    SelRow=4.
validateRow('F', SelRow) :-
    SelRow=5.
validateRow(_Row, SelRow) :-
    write('Invalid row\nSelect again'),
    readRow(NewRow),
    validateRow(NewRow, SelRow).

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