/* Main function
    Calls the initial functions and the game's loop
*/
play :-
    initial(GameState),
    display_game(GameState, Player),
    game_loop(GameState).

/* Creates the Board */
initial(GameState):-
    %initialBoard(GameState).
    %medBoard(GameState).
    finalBoard(GameState).
    
/* Display's the Board */
display_game(GameState, Player) :-
    printBoard(GameState).

/*Allows looping until game ends */
game_loop(GameState) :-
    playerTurn(GameState,'BLACKS', BlackPlayed, BlackGameState),
    (
        BlackPlayed =:= 1;
        BlackGameState = GameState
    ),
    playerTurn(BlackGameState, 'WHITES', WhitePlayed, WhiteGameState),
    (
        WhitePlayed =:= 1;
        WhiteGameState = BlackGameState
    ),
    (
        BlackPlayed =:= 0, WhitePlayed =:= 0, endGame(GameState); /* If no player could play, finish the game. */
        game_loop(WhiteGameState) /* Else, continue loop. */
    ).


/* Processes a player turn */
playerTurn(GameState, Player, Played, FinalGameState) :-
    canPlay(GameState, Player, Played),
    (
        Played =:= 0; 
        format('\n ~a turn\nSelect Piece:\n', Player),
        selectPiece(GameState, Player,FinalGameState),
        display_game(FinalGameState,Player)
    );
    Played=0,
    write('No possible captures! Skipping turn\n').

/* Verifies if a player can play. */
canPlay(GameState, Player, Played) :-
    NumRow = 0,
    NumCol = 0,
    GS = GameState,
    iterateMatrix(GameState, GS, NumRow, NumCol, Player, Played).
    %write('Can play\n').

/* Processes the end of the game: shows scores and chooses winner */
endGame(GameState) :-
    write('Game Over!\n'),
    checkWinner(GameState).