% Selects a Piece from the Board and moves it
move(GameState, Player,PieceAndMove,FinalMoveGameState) :-
    nth0(0, GameState, Columns),
    length(Columns, Cols),
    length(GameState, Rows),
    readColumn(Column),
    validateColumn(Column,Cols,SelColumn),
    readRow(Row),
    validateRow(Row,Rows,SelRow),
    length(PieceAndMove, LenghtMove),
    validateContent(SelColumn, SelRow, Player, GameState, FinalMoveGameState,PieceAndMove,0,LenghtMove,ChosenPiece),
    movePiece(GameState,Player,FinalMoveGameState,Cols,Rows,PieceAndMove,LenghtMove,ChosenPiece).

% Moves a selected Piece to a newly selected Cell
movePiece(GameState,Player,FinalMoveGameState,Cols,Rows,PieceAndMove,LenghtMove,ChosenPiece) :-
    write('\nMove to:\n'),
    readColumn(Column),
    validateColumn(Column,Cols,MoveColumn),
    readRow(Row),
    validateRow(Row,Rows,MoveRow),
    validateCapture(MoveRow, MoveColumn, GameState, Player, FinalMoveGameState,PieceAndMove,1,LenghtMove,ChosenPiece,Cols,Rows).

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
validateColumn(_Column, Cols, SelColumn) :-
    write('Invalid column\nSelect again\n'),
    skip_line,
    readColumn(NewColumn),
    validateColumn(NewColumn, Cols, SelColumn).
column(48, 0).
column(49, 1).
column(50, 2).
column(51, 3).
column(52, 4).
column(53, 5).
column(54, 6).
column(55, 7).
column(56, 8).


% Checks if user is selecting a row within boundaries
validateRow(Row, Rows, SelRow):-
    peek_char(Char),
    Char=='\n',
    row(Row, GameRow),
    GameRow<Rows,
    GameRow>=0,
    SelRow=GameRow,
    skip_line.
validateRow(_Row, Rows, SelRow) :-
    write('Invalid row\nSelect again\n'),
    skip_line,
    readRow(NewRow),
    validateRow(NewRow, Rows, SelRow).
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


% Checks if user is moving Piece to the same column or it's neighbouring ones
/*validateColumnMove(MoveColumn,SelColumn, MovedCol, FinalCol) :-
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
*/

% Reads option from Main Menu
readMenuOption:-
    write('Insert option '),
    get_code(Option),
    checkMenuOption(Option,5,SelOption),
    menuAction(SelOption).

readSizeOption(SelOption):-
    write('Insert option '),
    get_code(Option),
    checkMenuOption(Option,3,SelOption).

readDifficultyOption(SelOption):-
    write('Insert option '),
    get_code(Option),
    checkMenuOption(Option,2,SelOption).

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
    checkMenuOption(Option,NumOptions,SelOption).

menuOption(48,0).
menuOption(49,1).
menuOption(50,2).
menuOption(51,3).
menuOption(52,4).
menuOption(53,5).
menuOption(54,6).
menuOption(55,7).
menuOption(56,8).
menuOption(57,9).

% Deals with Menu option
menuAction(0):-
    write('\nExiting\n').
menuAction(1):-
    printBoards,
    readSizeOption(Size),
    initial(GameState,Size),
    display_game(GameState, _),
    game_loop(GameState,'BLACKS','HH',_).
menuAction(2):-
    printBoards,
    readSizeOption(Size),
    printDifficulties,
    readDifficultyOption(Difficulty),
    initial(GameState,Size),
    display_game(GameState, _),
    game_loop(GameState,'BLACKS','HC',Difficulty).
menuAction(3):-
    printBoards,
    readSizeOption(Size),
    printDifficulties,
    readDifficultyOption(Difficulty),
    initial(GameState,Size),
    display_game(GameState, _),
    game_loop(GameState,'BLACKS','CH',Difficulty).
menuAction(4):-
    printBoards,
    readSizeOption(Size),
    printDifficulties,
    readDifficultyOption(Difficulty),
    initial(GameState,Size),
    display_game(GameState, _),
    game_loop(GameState,'BLACKS','CC',Difficulty).