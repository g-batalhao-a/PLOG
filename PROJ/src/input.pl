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
    validateColumnMove(MoveColumn,SelColumn),
    readRow(Row),
    validateRow(Row,MoveRow),
    validateRowMove(MoveRow,SelRow),
    checkSamePos(MoveRow,MoveColumn,SelRow,SelColumn,GameState,Player),
    validateCapture(MoveRow,MoveColumn,SelRow,SelColumn,GameState,Player,Content,FinalMoveGameState).

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

validateColumnMove(MoveColumn,SelColumn) :-
    MoveColumn=:=SelColumn;
    MoveColumn=:=SelColumn+1;
    MoveColumn=:=SelColumn-1;
    (
        write('Invalid Column Move\nSelect again\n'),
        readColumn(NewColumn),
        validateColumn(NewColumn, NewMoveColumn),
        validateColumnMove(NewMoveColumn,SelColumn)
    ).

validateRowMove(MoveRow,SelRow) :-
    MoveRow=:=SelRow;
    MoveRow=:=SelRow+1;
    MoveRow=:=SelRow-1;
    (
        write('Invalid Row Move\nSelect again\n'),
        readRow(NewRow),
        validateRow(NewRow, NewMoveRow),
        validateRowMove(NewMoveRow,SelRow)
    ).

checkSamePos(MoveRow,MoveColumn,SelRow,SelColumn,GameState,Player) :-   /*If input isn't correct the first time this bugs, only seems to recognise change in column and not row*/
    (MoveColumn=\=SelColumn, MoveRow=\=SelRow);
    (MoveColumn=:=SelColumn, MoveRow=\=SelRow);
    (MoveColumn=\=SelColumn, MoveRow=:=SelRow);
    write('Cant move to same space!\nSelect again\n'),
    movePiece(GameState,Player,SelColumn,SelRow).
    

validateCapture(MoveRow,MoveColumn,SelRow,SelColumn,GameState,Player,Content,FinalMoveGameState) :-
    getCellContent(MoveColumn,MoveRow,MoveContent,GameState),
    (   verifyPiece(MoveContent),
        replaceCell(GameState,SelRow,SelColumn,'empty',NewGameState),
        replaceCell(NewGameState,MoveRow,MoveColumn,Content,FinalMoveGameState);
        (write('Must capture a piece!\n'),
        selectPiece(GameState,Player,FinalMoveGameState)
        )
    ).

validateContent(SelColumn, SelRow, Player, GameState,Content,FinalMoveGameState) :-
    getCellContent(SelColumn,SelRow,Content,GameState),
    (   verifyPlayer(Content,Player);
        (write('Invalid Piece\n'),
        selectPiece(GameState,Player,FinalMoveGameState)
        )
    ).

verifyPiece(Content) :-
    Content \= 'empty'.

verifyPlayer('black','BLACKS').
verifyPlayer('white','WHITES').