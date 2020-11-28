% Selects a Piece from the Board and moves it
move(GameState,PieceAndMove,FinalMoveGameState) :-
    selectPiece(GameState,PieceAndMove,FinalMoveGameState, LengthMove, ChosenPiece),
    movePiece(GameState,FinalMoveGameState,PieceAndMove,LengthMove,ChosenPiece).

% Predicate that reads user input (piece selection) and validates the selection
selectPiece(GameState,PieceAndMove,FinalMoveGameState, LengthMove, ChosenPiece) :-
    readInputs(GameState,SelColumn,SelRow),
    length(PieceAndMove, LengthMove),
    validateContent(SelColumn, SelRow, GameState, FinalMoveGameState,PieceAndMove,0,LengthMove,ChosenPiece).

% Predicate that reads user input (cell selection) and validates the move of
% the previously selected piece
movePiece(GameState,FinalMoveGameState,PieceAndMove,LengthMove,ChosenPiece) :-
    write('\nMove to:\n'),
    readInputs(GameState,MoveColumn,MoveRow),
    validateCapture(MoveRow, MoveColumn, GameState, FinalMoveGameState,PieceAndMove,1,LengthMove,ChosenPiece).

% Reads the User's inputs - Row & Column
readInputs(GameState,SelColumn,SelRow):-
    nth0(0, GameState, Columns),
    length(Columns, Cols),
    length(GameState, Rows),
    readColumn(Column),
    validateColumn(Column,Cols,SelColumn),
    readRow(Row),
    validateRow(Row,Rows,SelRow).

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

% Reads option from Main Menu
readMenuOption:-
    write('Insert option: '),
    get_code(Option),
    checkMenuOption(Option,5,SelOption),
    menuAction(SelOption).

% Reads option from Board Size Menu
readSizeOption(SelOption):-
    write('Insert board size option: '),
    get_code(Option),
    checkMenuOption(Option,4,SelOption).

% Reads option from Difficulty Menu
readDifficultyOption(SelOption):-
    write('Insert bot difficulty option: '),
    get_code(Option),
    checkMenuOption(Option,3,SelOption).

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
    write('Insert option: '),
    get_code(Option),
    checkMenuOption(Option,NumOptions,SelOption).

menuOption(48,0).
menuOption(49,1).
menuOption(50,2).
menuOption(51,3).
menuOption(52,4).

% Predicates that deal with Menu option
% Exits program
menuAction(0):-
    write('\nExiting\n').
% Starts player vs player
menuAction(1):-
    printBoards,
    readSizeOption(Size),
    initial(GameState,Size),
    display_game(GameState, _),
    game_loop(GameState,'BLACKS','HH',_).
% Starts player vs computer
menuAction(2):-
    printBoards,
    readSizeOption(Size),
    printDifficulties,
    readDifficultyOption(Difficulty1),
    parseDifficulties(Difficulty1,_,Difficulty),
    initial(GameState,Size),
    display_game(GameState, _),
    game_loop(GameState,'BLACKS','HC',Difficulty).
% Starts computer vs player
menuAction(3):-
    printBoards,
    readSizeOption(Size),
    printDifficulties,
    readDifficultyOption(Difficulty1),
    parseDifficulties(Difficulty1,_,Difficulty),
    initial(GameState,Size),
    display_game(GameState, _),
    game_loop(GameState,'BLACKS','CH',Difficulty).
% Starts computer vs computer
menuAction(4):-
    printBoards,
    readSizeOption(Size),
    printDifficulties,
    readDifficultyOption(Difficulty1),
    printDifficulties,
    readDifficultyOption(Difficulty2),
    parseDifficulties(Difficulty1,Difficulty2,Difficulty),
    initial(GameState,Size),
    display_game(GameState, _),
    game_loop(GameState,'BLACKS','CC',Difficulty).

% Function that transforms 1,1 into '11', for example
parseDifficulties(Difficulty1,Difficulty2,Difficulty):-
    number(Difficulty1,Dif1), number(Difficulty2,Dif2),
    composeString(Dif1,Dif2,Difficulty).
