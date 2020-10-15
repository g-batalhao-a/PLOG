getCellContent(SelColumn, SelRow, Content, GameState) :-
    nth0(SelRow, GameState, BoardRow),
    nth0(SelColumn, BoardRow, Content),
    format('\n Piece: ~d ~d', [SelColumn, SelRow]),
    format('\nValue: ~a\n', Content).

replaceCell(SelColumn,SelRow,Content,GameState) :-
    nth0(SelRow, GameState, BoardRow),
    nth0(SelColumn, BoardRow, Content),
