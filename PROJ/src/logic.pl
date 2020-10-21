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
    countWhite(GameState,WhitePoints),
    countBlack(GameState,BlackPoints),
    (
        WhitePoints<BlackPoints,write('WHITE WINS!!!!\n')    
    );
    (
        WhitePoints>BlackPoints,write('BLACK WINS!!!!\n') 
    ). %Must make function to check highest stack

countBlack(GameState,BlackPoints):-
    iterate(GameState,'BLACKS',Points),
    write('BLACKS POINTS: '),
    write(Points),
    nl,
    BlackPoints=Points.

countWhite(GameState,WhitePoints):-
    iterate(GameState,'WHITES',Points),
    write('WHITES POINTS: '),
    write(Points),
    nl,
    WhitePoints=Points.

iterate(GameState,Player,Result):-
    iterate(GameState,Player,0,Result).

iterate([], Player, Result, Result).

iterate([R|Rs], Player, Acc, Result) :-
    findStack(R, Player, ListPoints),
    NewPoints is Acc+ListPoints,
    iterate(Rs, Player, NewPoints, Result).

findStack(List, Player, Sum):- 
    findStack(List,Player,0,Sum).

findStack([],Player,Acc,Acc).

findStack([Head|Tail], Player, PrevAcc, Sum):-
    (
        verifyPlayer(Head, Player),
        countPoints(Head,X),
        NewAcc is X+PrevAcc,
        findStack(Tail, Player, NewAcc,Sum)
    );
    (
        findStack(Tail, Player, PrevAcc,Sum)
    ).   

countPoints(List,Acc):-
    write(List),nl,
    findall(Point, (member(Y,List),value(Y,Point)), PointList),
    sumlist(PointList, Acc).

% Assigns values to pieces
value(green,1).
value(white,0).
value(black,0).