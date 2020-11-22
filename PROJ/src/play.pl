% Creates the Board
initial(GameState,Board):-
    initialBoard(GameState,Board).
    %medBoard(GameState).
    %finalBoard(GameState).
    
% Displays the Board
display_game(GameState, _) :-
    printBoard(GameState).

% Loops until a game over situation
game_loop(GameState,Player,Type,Level) :-
    atom_chars(Type, GameType),
    nth0(0,GameType,NowPlaying),
    nth0(1,GameType,NextPlaying),
    playerTurn(GameState,Player, NewGameState,NowPlaying,Level),    
    display_game(NewGameState,Player),
    write('Next turn\n'),
    checkAvailableMoves(NewGameState,Done),
    atom_concat(NextPlaying, NowPlaying, NewGameType),
    processAvailableMoves(NewGameState,Player,Done,NewGameType,Level). 


% Processes a human player turn
playerTurn(GameState, Player, FinalGameState,PlayerType,Level) :-
    valid_moves(GameState, Player, ListOfMoves,PieceAndMove),
    %write(ListOfMoves),
    %nl,%*/
    %write(PieceAndMove),
    %nl,
    (
        exclude(empty, ListOfMoves, Result),
        (
            \+ length(Result, 0),
            format('\n ~a turn\nSelect Piece:\n', Player),
            typeOfMove(GameState, Player,PieceAndMove,FinalGameState,PlayerType,Level)
        );
        (
            format('\n No moves available for ~a\nSkipping turn\n',Player),
            FinalGameState=GameState
        )
    ).
playerTurn(GameState, Player, FinalGameState,_,_) :-
    format('No possible captures! Skipping ~a turn\n',Player),
    FinalGameState=GameState.

typeOfMove(GameState, Player,PieceAndMove,FinalGameState,'H',_):-
    move(GameState, Player,PieceAndMove,FinalGameState).

typeOfMove(GameState, Player,PieceAndMove,FinalGameState,'C',Level):-
    choose_move(GameState, PieceAndMove, Player,Level,Move),
    Move=[ChosenPiece,Check,MoveColumn,MoveRow],
    nth0(ChosenPiece,PieceAndMove,MoveSet),
    length(MoveSet,LengthMove),
    validateCapture(MoveRow,MoveColumn,GameState,_,FinalGameState,PieceAndMove,Check,LengthMove,ChosenPiece,_,_).

% Verifies if a player can play
valid_moves(GameState, Player, ListOfMoves,PieceAndMove) :-
    nth0(0, GameState, Row),
    length(Row, NumCols),
    length(GameState,NumRows),
    iterateMatrix(GameState, NumRows, NumCols, Player, ListOfMoves,PieceAndMove).
    %write('Can play\n').

% Verifies if there are still legal moves for, at leats, one player
checkAvailableMoves(GameState,Done):-
    valid_moves(GameState, 'BLACKS', BlackMoves,_),
    valid_moves(GameState, 'WHITES', WhiteMoves,_),
    exclude(empty, BlackMoves, ResultBlacks),
    exclude(empty, WhiteMoves, ResultWhites),
    %write(BlackMoves),
    %nl,
    %write(WhiteMoves),
    %nl,
    (
        ( 
            \+ length(ResultBlacks, 0),
            %write('BLACKS still have moves\n'),
            Done=0
        )
        ;
        ( 
            \+ length(ResultWhites, 0),
            %write('WHITES still have moves\n'),
            Done=0
        );
        write('NO MORE MOVES\n'),
        Done=1
    ).
% Processes the end of the game: shows scores and winner
game_over(GameState) :-
    write('Game Over!\n'),
    checkWinner(GameState).

% Processes the nextTurn
% If the Done flag is 0 (there are still moves available), go to next Player Turn
% If the Done flag is 1 (no more moves available), go to game_over
processAvailableMoves(GameState,Player,0,Type,Level):-
    (Player == 'BLACKS', game_loop(GameState, 'WHITES',Type,Level))
    ;
    (Player == 'WHITES', game_loop(GameState,'BLACKS',Type,Level)).

processAvailableMoves(GameState,_,1,_,_):-
    game_over(GameState).  
