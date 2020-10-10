selectPiece(GameState, Player) :-
    readColumn(Column),
    validateColumn(Column,SelColumn),
    readRow(Row),
    validateRow(Row,SelRow),
    validateContent(SelColumn, SelRow, Player, GameState).

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

validateContent(SelColumn, SelRow, Player, GameState) :-
    getCellContent(SelColumn,SelRow,Content,GameState),
    (   verifyPlayer(Content,Player);
        (write('Invalid Piece\n'),
        selectPiece(GameState,Player)
        )
    ).

verifyPlayer('black','BLACKS').
verifyPlayer('white','WHITES').