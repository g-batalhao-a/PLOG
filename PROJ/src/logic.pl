% Validates a capture by a player
% Gets the content of the cell that the player wants to move to
% and verifies if it is not empty
% If it is not, it replaces the previous cell with ['empty']
% and updates the new cell with the value of the piece at the Head
% Ex: Black Piece move to Green Piece -> ['black','green']
% If it is empty, repeats the selection of the piece that the player
% wants to move
validateCapture(MoveRow,MoveColumn,SelRow,SelColumn,GameState,Player,Content,FinalMoveGameState) :-
    getCellContent(MoveColumn,MoveRow,MoveContent,GameState),
    (   verifyPiece(MoveContent),
        replaceEmpty(GameState,SelRow,SelColumn,['empty'],NewGameState),
        replaceCell(NewGameState,MoveRow,MoveColumn,Content,FinalMoveGameState),
        getCellContent(MoveColumn,MoveRow,AfterMoveContent,FinalMoveGameState);
        (write('Must capture a piece!\n'),
        selectPiece(GameState,Player,FinalMoveGameState)
        )
    ).
% Validates a piece by a player
% Gets the content of the cell that the player wants to move
% and verifies if it is the apropriate colour
% If it is not, it repeats the selection of the piece that the player
% wants to move
validateContent(SelColumn, SelRow, Player, GameState,Content,FinalMoveGameState) :-
    getCellContent(SelColumn,SelRow,Content,GameState),
    (   verifyPlayer(Content,Player);
        (write('Invalid Piece\n'),
        selectPiece(GameState,Player,FinalMoveGameState)
        )
    ).

% Function to check if the cell is empty
verifyPiece(Content) :-
    Content \= [empty].

% Fucntions to check if the player selected a correct piece
verifyPlayer(L,'BLACKS'):- nth0(0, L, black).
verifyPlayer(L,'WHITES'):- nth0(0, L, white).

checkWinner(GameState):-
    countWhite(GameState,WhitePoints,WhiteMaxLength),
    countBlack(GameState,BlackPoints,BlackMaxLength),
    (
        BlackPoints@<WhitePoints,write('WHITE WINS!!!!\n');
        WhitePoints@<BlackPoints,write('BLACK WINS!!!!\n');
        (
            write('TIED POINTS!!!!\nChecking for higher stack...\n'),
            (
              (BlackMaxLength@<WhiteMaxLength,write('WHITE WINS!!!!\n'));
              (WhiteMaxLength@<BlackMaxLength,write('BLACK WINS!!!!\n'));
              (write('TIED GAME\nRestarting new one\n'),play)
              )
      
          )
    ). %Must make function to check highest stack

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

iterate(GameState,Player,Result, FinalLength):-
    iterate(GameState,Player,0,Result,0,FinalLength).

iterate([], Player, Result, Result, FinalLength,FinalLength).

iterate([R|Rs], Player, Acc, Result,MedLength,FinalLength) :-
    findStack(R, Player, ListPoints,MedLength, ListLength),
    NewPoints is Acc+ListPoints,
    MaxLength is ListLength,
    iterate(Rs, Player, NewPoints, Result,MaxLength,FinalLength).

findStack(List, Player, Sum,MedLength,ListLength):- 
    findStack(List,Player,0,Sum,MedLength,ListLength).

findStack([],Player,Acc,Acc,Length,Length).

findStack([Head|Tail], Player, PrevAcc, Sum,PrevLength,Length):-
    (
        verifyPlayer(Head, Player),
        length(Head, MedLength),
        write('Prev Length: '),
        write(PrevLength),
        nl,
        write('Actual Length: '),
        write(MedLength),
        nl,
        countPoints(Head,X),
        NewAcc is X+PrevAcc,
        (
            (PrevLength=<MedLength, NewLength is MedLength);
            (MedLength@<PrevLength, NewLength is PrevLength)
        ),
        write('New Length: '),
        write(NewLength),
        nl,
        findStack(Tail, Player, NewAcc,Sum,NewLength,Length)
    );
    (
        findStack(Tail, Player, PrevAcc,Sum,PrevLength,Length)
    ).   

countPoints(List,Acc):-
    write(List),nl,
    findall(Point, (member(Y,List),value(Y,Point)), PointList),
    sumlist(PointList, Acc).

% Assigns values to pieces
value(green,1).
value(white,0).
value(black,0).