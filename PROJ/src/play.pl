% Creates the Board
initial(GameState,Board):-
    initialBoard(GameState,Board).
    %medBoard(GameState).
    %finalBoard(GameState).
    
% Displays the Board
display_game(GameState, _) :-
    % write(GameState),
    printBoard(GameState).

% Loops until a game over situation
game_loop(GameState,Player,Type,Level) :-
    decomposeString(Type,NowPlaying,NextPlaying),
    decomposeString(Level,NowLevel,NextLevel),
    playerTurn(GameState,Player, NewGameState,NowPlaying,NowLevel),    
    display_game(NewGameState,Player),
    write('Next turn\n'),
    checkAvailableMoves(NewGameState,Done),
    composeString(NextPlaying, NowPlaying, NewGameType),
    composeString(NextLevel,NowLevel,NewLevel),
    processAvailableMoves(NewGameState,Player,Done,NewGameType,NewLevel). 

% Decomposes GameType
decomposeString(Type,NowPlaying,NextPlaying):-
    atom_chars(Type, GameType),
    nth0(0,GameType,NowPlaying),
    nth0(1,GameType,NextPlaying).

% Composes GameType
composeString(NextPlaying, NowPlaying, NewGameType):-
    atom_concat(NextPlaying, NowPlaying, NewGameType).

% Processes a Player's turn
% If has available moves, moves a piece
% If not, skips turn
playerTurn(GameState, Player, FinalGameState,PlayerType,Level) :-
    valid_moves(GameState, Player,PieceAndMove),
    exclude(empty, PieceAndMove, Result),
    \+ length(Result, 0),
    format('\n ~a turn\nSelect Piece:\n', Player),
    typeOfMove(GameState, Player,PieceAndMove,FinalGameState,PlayerType,Level).

playerTurn(GameState, Player, FinalGameState,_,_) :-
    format('No possible captures! Skipping ~a turn\n',Player),
    FinalGameState=GameState.

% Type of Moves:
% If is human, invokes move (Requires user input)
% If is bot, invokes choose_move (Calculates random/best move)
typeOfMove(GameState, _,PieceAndMove,FinalGameState,'H',_):-
    move(GameState,PieceAndMove,FinalGameState).

typeOfMove(GameState, Player,PieceAndMove,FinalGameState,'C',Level):-
    choose_move(GameState, PieceAndMove, Player,Level,Move),
    Move=[ChosenPiece,Check,MoveColumn,MoveRow],
    nth0(ChosenPiece,PieceAndMove,MoveSet),
    length(MoveSet,LengthMove),
    validateCapture(MoveRow,MoveColumn,GameState,FinalGameState,PieceAndMove,Check,LengthMove,ChosenPiece).

% Verifies if a player can play
valid_moves(GameState, Player,ListOfMoves) :-
    nth0(0, GameState, Row),
    length(Row, NumCols),
    length(GameState,NumRows),
    iterateMatrix(GameState, NumRows, NumCols, Player,ListOfMoves).
    %write('Can play\n').

% Verifies if there are still legal moves for, at least, one player
checkAvailableMoves(GameState,Done):-
    valid_moves(GameState, 'BLACKS',BlackMoves),
    valid_moves(GameState, 'WHITES',WhiteMoves),
    exclude(empty, BlackMoves, ResultBlacks),
    exclude(empty, WhiteMoves, ResultWhites),
    (
        ( \+ length(ResultBlacks, 0), Done=0)
        ;
        ( \+ length(ResultWhites, 0), Done=0)
        ;
        ( write('NO MORE MOVES\n'), Done=1)
        
    ).
% Processes the end of the game: shows scores and winner
game_over(GameState,Winner) :-
    write('Game Over!\n'),
    checkWinner(GameState,Winner),
    processGameOver(Winner).

% Processes end action:
% Restarts game if tied
% Ends program if there is a winner
processGameOver('TIED'):-
    write('TIED GAME!!\nRestarting...\n'),
    play.

processGameOver(Winner):-
    format('\n ~a WINS!!!', Winner).

% Processes the nextTurn
% If the Done flag is 0 (there are still moves available), go to next Player Turn
% If the Done flag is 1 (no more moves available), go to game_over
processAvailableMoves(GameState,Player,0,Type,Level):-
    (Player == 'BLACKS', game_loop(GameState, 'WHITES',Type,Level))
    ;
    (Player == 'WHITES', game_loop(GameState,'BLACKS',Type,Level)).

processAvailableMoves(GameState,_,1,_,_):-
    game_over(GameState,_).

