%Randomly chooses a move
choose_move(_,PieceAndMove,_,1,Move):-
    length(PieceAndMove, AvailableMoves),
    %write(AvailableMoves),nl,   
    random(0, AvailableMoves, SelIndex),
    nth0(SelIndex, PieceAndMove, GoToMove),
    \+ length(GoToMove,1),
    %write(GoToMove),nl,
    nth0(0,GoToMove,SelectedPiece),
    SelectedPiece=[SelCol,SelRowNum],
    letter(SelRowNum,SelRow),
    write('Choosing Piece...\n'),
    sleep(1),    
    write('Chose: '),write(SelCol),write(' '),write(SelRow),nl,
    length(GoToMove, AvailableDirections),    
    random(1, AvailableDirections, MoveIndex),
    nth0(MoveIndex, GoToMove, MovingTo),
    %write(MovingTo),nl,
    MovingTo=[MovCol,MovRowNum],
    letter(MovRowNum,MovRow),
    write('Moving to...\n'),
    sleep(1),
    write('Moved to: '),write(MovCol),write(' '),write(MovRow),nl,
    Move=[SelIndex,MoveIndex,MovCol,MovRowNum].
    %write(Move),nl.

choose_move(GameState,PieceAndMove,Player,2,Move):-
    findall(
        Value-Piece-NMove-Index-MovInd,
        (
            nth0(Index,PieceAndMove,GoToMove),
            nth0(0,GoToMove,Piece),
            nth0(MovInd,GoToMove,NMove),
            MovInd\=0,
            value(GameState,NMove,Player,Value)

        ),
        ValueLists
    ),
    sort(ValueLists,SortedValues),
    reverse(SortedValues, DecrescValues),   
    nth0(0,DecrescValues,BestMove),
    BestMove=_-[SelCol,SelRow]-[MoveCol,MoveRow]-SelIndex-MoveIndex,
    write('Choosing Piece...\n'),
    sleep(1),    
    write('Chose: '),write(SelCol),write(' '),write(SelRow),nl,
    write('Moving to...\n'),
    sleep(1),
    write('Moved to: '),write(MoveCol),write(' '),write(MoveRow),nl,
    Move=[SelIndex,MoveIndex,MoveCol,MoveRow].

%If the piece chose has no moves
choose_move(GameState,PieceAndMove,Player,Level,Move):-
    write('Maybe not this one...\n'),
    sleep(1),
    choose_move(GameState,PieceAndMove,Player,Level,Move).

value(GameState, Piece, Player, Value):-
    Piece=[SelColumn,SelRow],
    getCellContent(SelColumn, SelRow, Content, GameState),
    countPoints(Content,Value).