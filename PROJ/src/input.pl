% Selects a Piece from the Board and moves it
move(GameState, Player,FinalMoveGameState) :-
    nth0(0, GameState, Columns),
    length(Columns, Cols),
    length(GameState, Rows),
    readColumn(Column),
    validateColumn(Column,Cols,SelColumn),
    readRow(Row),
    validateRow(Row,Rows,SelRow),
    validateContent(SelColumn, SelRow, Player, GameState, Content, FinalMoveGameState),
    movePiece(GameState,Player,SelColumn,SelRow, Content,FinalMoveGameState,Cols,Rows).

% Moves a selected Piece to a newly selected Cell
movePiece(GameState,Player,SelColumn,SelRow, Content,FinalMoveGameState,Cols,Rows) :-
    write('\nMove to:\n'),
    readColumn(Column),
    validateColumn(Column,Cols,MoveColumn),
    validateColumnMove(MoveColumn, SelColumn, MovedCol, FinalCol),
    readRow(Row),
    validateRow(Row,Rows,MoveRow),
    validateRowMove(MoveRow, SelRow, MovedCol, FinalRow),
    validateCapture(FinalRow, FinalCol, SelRow, SelColumn, GameState, Player, Content, FinalMoveGameState).

% Reads Column Input
readColumn(Column) :-
    write('- Column '),
    get_code(Column).

%Reads Row Input
readRow(Row) :-
    write('- Row '),
    get_char(Row).


% Checks if user is selecting a column within boundaries
validateColumn(Column, Cols, SelColumn):-
    peek_char(Char),
    Char=='\n',
    column(Column, GameCol),
    GameCol<Cols,
    GameCol>=0,
    SelColumn=GameCol,
    skip_line.
column(48, 0).
column(49, 1).
column(50, 2).
column(51, 3).
column(52, 4).
column(53, 5).
column(54, 6).
column(55, 7).
column(56, 8).
validateColumn(_Column, Cols, SelColumn) :-
    write('Invalid column\nSelect again\n'),
    skip_line,
    readColumn(NewColumn),
    validateColumn(NewColumn, Cols, SelColumn).

% Checks if user is selecting a row within boundaries
validateRow(Row, Rows, SelRow):-
    peek_char(Char),
    Char=='\n',
    row(Row, GameRow),
    GameRow<Rows,
    GameRow>=0,
    SelRow=GameRow,
    skip_line.
row('A', 0). 
row('a', 0).
row('B', 1).
row('b', 1).
row('C', 2).
row('c', 2).
row('D', 3).
row('d', 3).
row('E', 4).
row('e', 4).
row('F', 5).
row('f', 5).
row('G', 6).
row('g', 6).
row('H', 7).
row('h', 7).
row('I', 8).
row('i', 8).
validateRow(_Row, Rows, SelRow) :-
    write('Invalid row\nSelect again\n'),
    skip_line,
    readRow(NewRow),
    validateRow(NewRow, Rows, SelRow).

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

% Reads option from Main Menu
readMenuOption:-
    write('Insert option '),
    get_code(Option),
    checkMenuOption(Option,4,SelOption),
    write(Option),
    menuAction(SelOption).

% Validates Menu Option
checkMenuOption(Option,NumOptions,SelOption):-
    peek_char(Char),
    Char=='\n',
    menuOption(Option, Selection),
    Selection<NumOptions,
    Selection>=0,
    SelOption=Selection,
    skip_line.
checkMenuOption(_,NumOptions,SelOption):-
    write('Invalid option\nTry again\n'),
    skip_line,
    write('Insert option '),
    get_code(Option),
    checkMenuOption(Option,4,SelOption).

menuOption(48,0).
menuOption(49,1).
menuOption(50,2).
menuOption(51,3).

% Deals with Menu option
menuAction(0):-
    write('\nExiting\n').
menuAction(1):-
    initial(GameState,0),
    display_game(GameState, Player),
    game_loop(GameState,'BLACKS').
menuAction(2):-
    initial(GameState,1),
    display_game(GameState, Player),
    game_loop(GameState,'BLACKS').
menuAction(3):-
    initial(GameState,2),
    display_game(GameState, Player),
    game_loop(GameState,'BLACKS').