% Randomly chooses a move from list of available moves
choose_move(_,PieceAndMove,_,'1',Move):-
    getRandomPiece(PieceAndMove,SelIndex,SelectedPiece,GoToMove),
    getRandomPiece(GoToMove,MoveIndex,MovingTo),
    SelectedPiece=[SelCol,SelRow],
    MovingTo=[MoveCol,MoveRow],
    writeBotAction(SelCol,SelRow,0),
    writeBotAction(MoveCol,MoveRow,1),
    Move=[SelIndex,MoveIndex,MoveCol,MoveRow].
    %write(Move),nl.

% Chooses the best move, based on move value (Highest amount of points)
choose_move(GameState,PieceAndMove,Player,'2',Move):-
    value(GameState,PieceAndMove,Player,ValuesList),   
    nth0(0,ValuesList,BestMove),
    BestMove=_-[SelCol,SelRow]-[MoveCol,MoveRow]-SelIndex-MoveIndex,
    writeBotAction(SelCol,SelRow,0),
    writeBotAction(MoveCol,MoveRow,1),
    Move=[SelIndex,MoveIndex,MoveCol,MoveRow].

%If the piece chosen has no moves
choose_move(GameState,PieceAndMove,Player,Level,Move):-
    write('Maybe not this one...\n'),
    sleep(1),
    choose_move(GameState,PieceAndMove,Player,Level,Move).

% Gets a random Piece to move
getRandomPiece(PieceAndMove,SelIndex,SelectedPiece,GoToMove):-
    length(PieceAndMove, AvailableMoves),
    random(0, AvailableMoves, SelIndex),
    nth0(SelIndex, PieceAndMove, GoToMove),
    \+ length(GoToMove,1),
    nth0(0,GoToMove,SelectedPiece).

% Gets a random cell to move to
getRandomPiece(PieceAndMove,SelIndex,SelectedPiece):-
    length(PieceAndMove, AvailableMoves),
    random(1, AvailableMoves, SelIndex),
    nth0(SelIndex, PieceAndMove, SelectedPiece).


% Get list of board evaluation
value(GameState,PieceAndMove,Player,Value):-
    findall(
        ValuePiece-Piece-NMove-Index-MovInd,
        (
            nth0(Index,PieceAndMove,GoToMove),
            nth0(0,GoToMove,Piece),
            nth0(MovInd,GoToMove,NMove),
            MovInd\=0,
            pieceValue(GameState,NMove,Player,ValuePiece)

        ),
        ValueLists
    ),
    sort(ValueLists,SortedValues),
    reverse(SortedValues, Value).

% Evaluation of the board (points per stack)
pieceValue(GameState, Piece, Player, ValuePiece):-
    Piece=[SelColumn,SelRow],
    getCellContent(SelColumn, SelRow, Content, GameState),
    countPoints(Content,ValuePiece).