% Validates a capture by a player
% Gets the content of the cell that the player wants to move to
% and verifies if it is not empty
% If it is not, it replaces the previous cell with ['empty']
% and updates the new cell with the value of the piece at the Head
% Ex: Black Piece move to Green Piece -> ['black','green']
% If it is empty, repeats the selection of the piece that the player
% wants to move
validateCapture(_,_,GameState,FinalMoveGameState,PieceAndMove,LenghtMove,LenghtMove,_) :-
    write('Invalid capture!\nMove Again:\n'),
    move(GameState,PieceAndMove,FinalMoveGameState).

validateCapture(MoveRow,MoveColumn,GameState,FinalMoveGameState,PieceAndMove,Check,_,ChosenPiece) :-
    nth0(ChosenPiece,PieceAndMove,PieceMove),
    %write(PieceMove),nl,
    nth0(Check,PieceMove,[MoveColumn,MoveRow]),
    nth0(0,PieceMove,[SelColumn,SelRow]),
    
    getCellContent(SelColumn,SelRow,Content,GameState),
    replaceEmpty(GameState,SelRow,SelColumn,[empty],NewGameState),
    replaceCell(NewGameState,MoveRow,MoveColumn,Content,FinalMoveGameState).

validateCapture(MoveRow,MoveColumn,GameState,FinalMoveGameState,PieceAndMove,Check,LenghtMove,ChosenPiece) :-
    NewCheck is Check+1,
    validateCapture(MoveRow,MoveColumn,GameState,FinalMoveGameState,PieceAndMove,NewCheck,LenghtMove,ChosenPiece).

% Validates a piece by a player
% Gets the content of the cell that the player wants to move
% and verifies if it is the apropriate colour
% If it is not, it repeats the selection of the piece that the player
% wants to move
validateContent(_, _, GameState,FinalMoveGameState,PieceAndMove,LenghtMove,LenghtMove,_) :-
    write('Invalid Piece\n'),
    move(GameState,PieceAndMove,FinalMoveGameState).

validateContent(SelColumn, SelRow, _,_,PieceAndMove,Check,_,ChosenPiece) :-
    nth0(Check,PieceAndMove,PieceMove),
    nth0(0,PieceMove,[SelColumn,SelRow]),
    ChosenPiece is Check.

validateContent(SelColumn, SelRow, GameState,FinalMoveGameState,PieceAndMove,Check,LenghtMove,ChosenPiece) :-
    NewCheck is Check+1,
    validateContent(SelColumn, SelRow, GameState,FinalMoveGameState,PieceAndMove,NewCheck,LenghtMove,ChosenPiece).

empty([_]).
% Function to check if the cell is empty
verifyPiece(Content) :-
    Content \= [empty].

% Functions to check if the player selected a correct piece
verifyPlayer(L,'BLACKS'):- nth0(0, L, black).
verifyPlayer(L,'WHITES'):- nth0(0, L, white).

%Checks for the winner or restarts the game
checkWinner(GameState,Winner):-
    countWhite(GameState,WhitePoints,WhiteMaxLength),
    countBlack(GameState,BlackPoints,BlackMaxLength),
    (
        BlackPoints@<WhitePoints,Winner='WHITE';
        WhitePoints@<BlackPoints,Winner='BLACK';
        (
            write('TIED POINTS!!!!\nChecking for higher stack...\n'),
            (
              (BlackMaxLength@<WhiteMaxLength,Winner='WHITE');
              (WhiteMaxLength@<BlackMaxLength,Winner='BLACK');
                (Winner='TIED')
            )
      
          )
    ).

% Counts the Black PLayer's points and his highest stack
countBlack(GameState,BlackPoints,BlackMaxLength):-
    iterate(GameState,'BLACKS',Points, BlackLength),
    write('BLACKS POINTS: '),
    write(Points),
    nl,
    write('BLACK MAX LENGTH: '),
    write(BlackLength),
    nl,
    BlackPoints=Points,
    BlackMaxLength=BlackLength.

% Counts the White PLayer's points and his highest stack
countWhite(GameState,WhitePoints,WhiteMaxLength):-
    iterate(GameState,'WHITES',Points, WhiteLength),
    write('WHITES POINTS: '),
    write(Points),
    nl,
    write('WHITE MAX LENGTH: '),
    write(WhiteLength),
    nl,
    WhitePoints=Points,
    WhiteMaxLength=WhiteLength.

% Iterates over matrix
iterate(GameState,Player,Result, FinalLength):-
    iterate(GameState,Player,0,Result,0,FinalLength).
iterate([], _, Result, Result, FinalLength,FinalLength).
iterate([R|Rs], Player, Acc, Result,MedLength,FinalLength) :-
    findStack(R, Player, ListPoints,MedLength, ListLength),
    NewPoints is Acc+ListPoints,
    MaxLength is ListLength,
    iterate(Rs, Player, NewPoints, Result,MaxLength,FinalLength).

% Finds stack that corresponds to a Player, adds its value to the points
% and updates the maximum stack height found
findStack(List, Player, Sum,MedLength,ListLength):- 
    findStack(List,Player,0,Sum,MedLength,ListLength).
findStack([],_,Acc,Acc,Length,Length).
findStack([Head|Tail], Player, PrevAcc, Sum,PrevLength,Length):-
    (
        verifyPlayer(Head, Player),
        length(Head, MedLength),
        %write('Prev Length: '),
        %write(PrevLength),
        %nl,
        %write('Actual Length: '),
        %write(MedLength),
        %nl,
        countPoints(Head,X),
        NewAcc is X+PrevAcc,
        (
            (PrevLength=<MedLength, NewLength is MedLength);
            (MedLength@<PrevLength, NewLength is PrevLength)
        ),
        %write('New Length: '),
        %write(NewLength),
        %nl,
        findStack(Tail, Player, NewAcc,Sum,NewLength,Length)
    );
    (
        findStack(Tail, Player, PrevAcc,Sum,PrevLength,Length)
    ).   

%Counts Points in a Cell
countPoints(List,Acc):-
    %write(List),nl,
    findall(Point, (member(Y,List),value(Y,Point)), PointList),
    sumlist(PointList, Acc).

% Assigns values to pieces
value(green,1).
value(white,0).
value(black,0).