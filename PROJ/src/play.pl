% Creates the Board
initial(GameState):-
    %initialBoard(GameState).
    medBoard(GameState).
    %finalBoard(GameState).
    
% Displays the Board
display_game(GameState, Player) :-
    printBoard(GameState).

% Loops until a game over situation
game_loop(GameState,Player) :-
    playerTurn(GameState,Player, NewGameState),
    write('Next turn\n'),
    checkAvailableMoves(NewGameState,Done),
    write(Done),nl,
    processAvailableMoves(NewGameState,Player,Done). 


% Processes a player turn
playerTurn(GameState, Player, FinalGameState) :-
    valid_moves(GameState, Player, ListOfMoves),
    write(ListOfMoves),
    nl,
    (
        (
            \+ length(ListOfMoves, 0),
            format('\n ~a turn\nSelect Piece:\n', Player),
            move(GameState, Player,FinalGameState)
        );
        (
            format('\n No moves available for ~a\nSkipping turn\n',Player),
            FinalGameState=GameState
        )
    ),
    display_game(FinalGameState,Player).

playerTurn(GameState, Player, FinalGameState) :-
    format('No possible captures! Skipping ~a turn\n',Player),
    FinalGameState=GameState.

% Verifies if a player can play
valid_moves(GameState, Player, ListOfMoves) :-
    NumRow = 0,
    NumCol = 0,
    GS = GameState,
    iterateMatrix(GameState, GS, NumRow, NumCol, Player, ListOfMoves).
    %write('Can play\n').

% Verifies if there are still legal moves for, at leats, one player
checkAvailableMoves(GameState,Done):-
    valid_moves(GameState, 'BLACKS', BlackMoves),
    valid_moves(GameState, 'WHITES', WhiteMoves),
    %write(BlackMoves),
    %nl,
    %write(WhiteMoves),
    %nl,
    (
        ( 
            \+ length(BlackMoves, 0),
            write('BLACKS still have moves\n'),
            Done=0
        )
        ;
        ( 
            \+ length(WhiteMoves, 0),
            write('WHITES still have moves\n'),
            Done=0
        );
        write('NO MORE MOVES\n'),
        Done=1
    ).
% Processes the end of the game: shows scores and winner
game_over(GameState) :-
    write('Game Over!\n'),
    checkWinner(GameState).

% Processes the
processAvailableMoves(GameState,Player,0):-
    (Player == 'BLACKS', game_loop(GameState, 'WHITES'))
    ;
    (Player == 'WHITES', game_loop(GameState,'BLACKS')).  

processAvailableMoves(GameState,Player,1):-
    game_over(GameState).  
