/* Main function
    Calls the initial functions and the game's loop
*/
play :-
    initial(GameState),
    display_game(GameState, Player),
    game_loop(GameState).

/*Creates the Board*/
initial(GameState):-
    initialBoard(GameState).
    
/* Display's the Board */
display_game(GameState, Player) :-
    printBoard(GameState).

/*Allows looping until game ends*/
game_loop(GameState) :-
    playerTurn(GameState,'BLACKS')/*,
    (   (checkGameState(GameState,'black'),write('\nBlack won\n'));
        playerTurn(GameState,'white'),
            (   (checkGameState(GameState,'white'),write('\nWhite won\n'));
                game_loop(GameState)
            )
    )*/.


playerTurn(GameState, Player) :-
    format('\n ~a turn\n', Player),
    selectPiece(GameState, Player).