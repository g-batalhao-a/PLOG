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
    Content \= ['empty'].

% Fucntions to check if the player selected a correct piece
verifyPlayer(['black'|_],'BLACKS').
verifyPlayer(['white'|_],'WHITES').

checkWinner(GameState):-
    countWhite(GameState,WhitePoints),
    countBlack(GameState,BlackPoints).

countBlack(GameState,BlackPoints):-
    Acc=0,
    iterate(GameState,'WHITES',Points, Acc),
    write('WHITES POINTS: '),
    write(Acc),
    nl,
    BlackPoints=Acc.

countWhite(GameState,WhitePoints):-
    Acc=0,
    iterate(GameState,'WHITES',Points, Acc),
    write('WHITES POINTS: '),
    write(Acc),
    nl,
    WhitePoints=Acc.

iterate([], Player, Points, Acc).
iterate([R|Rs], Player, Points,Acc) :-
    findStack(R, Player, Points,Acc),
    iterate(Rs, Player, Points, Acc).


findStack([], Player, Points,Acc).

findStack([Head|Tail], Player, Points,Acc):-
(
    verifyPlayer(Head, Player),
    countPoints(Head,Points,Acc)

);
(
    findStack(Tail, Player, Points,Acc)
).   

countPoints([],Points,Acc).
countPoints([Head|Tail], Points,Acc):-
    (   
        Head=='green',
        Acc1 is Acc+1,
        countPoints(Tail,Points,Acc1)
    );
    (
        countPoints(Tail,Points,Acc)
    )
    .

