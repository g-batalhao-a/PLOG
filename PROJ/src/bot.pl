%Randomly chooses a move
choose_move(PieceAndMove,_,0,Move):-
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
    
%If the piece chose has no moves
choose_move(PieceAndMove,Player,0,Move):-
    write('Maybe not this one...\n'),
    sleep(1),
    choose_move(PieceAndMove,Player,0,Move).