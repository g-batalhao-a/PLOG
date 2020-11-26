player('Danny', 'Best Player Ever', 27).
player('Annie', 'Worst Player Ever', 24).
player('Harry', 'A-Star Player', 26).
player('Manny', 'The Player', 14).
player('Jonny', 'A Player', 16).

game('5 ATG', [action, adventure, open-world, multiplayer], 18).
game('Carrier Shift: Game Over', [action, fps, multiplayer, shooter], 16
).
game('Duas Botas', [action, free, strategy, moba], 12).

played('Best Player Ever', '5 ATG', 3, 83).
played('Worst Player Ever', '5 ATG', 52, 9).
played('The Player', 'Carrier Shift: Game Over', 44, 22).
played('A Player', 'Carrier Shift: Game Over', 48, 24).
played('A-Star Player', 'Duas Botas', 37, 16).
played('Best Player Ever', 'Duas Botas', 9, 22).

playedALot(Player):-
    played(Player,_,H,_),H>=50.

isAgeAppropriate(Name,Game):-
    player(Name,_,Age),
    game(Game,_,MAge),
    Age>=MAge.

:-dynamic played/4.

updatePlayer(Player,Game,Hours,Percentage):-
    retract(played(Player,Game,PH,PP)),
    NH is PH + Hours, NP is PP +Percentage,
    assert(played(Player,Game,NH,NP)).


goList(_,[]).
goList(Game,Cat,[Cat|R],Age):-
    write(Game),write( '('),write(Age),write(')\n').
goList(Game,Cat,[_|R],Age):-
    goList(Game,Cat,R,Age).

listGamesOfCategory(Cat):-
    game(Game,Cats,Age),
    goList(Game,Cat,Cats,Age),
    fail.
listGamesOfCategory(_).

goList(_,[],L,L,Acc,Acc).
goList(Player,[Game|R],L,ListOftimes,Acc,SumTimes):-
    played(Player,Game,H,_),
    append(L,[H],NL), NAcc is Acc+H,
    goList(Player, R, NL, ListOftimes, NAcc, SumTimes).

goList(Player,[Game|R],L,ListOftimes,Acc,SumTimes):-
    append(L,[0],NL), NAcc is Acc+0,
    goList(Player, R, NL, ListOftimes, NAcc, SumTimes).

timePlayingGames(Player, Games, ListOftimes, SumTimes):-
    goList(Player, Games, [], ListOftimes, 0, SumTimes),!.



fewHours(Player, Games):-
    fewHours(Player, [], [], Games),!.

fewHours(Player, ParsedGames, VerifGames, Games):-
    played(Player, Game, Hours, _Percentage),
    \+member(Game, ParsedGames),
    append(ParsedGames, [Game], AuxParsed),
    (
        (
            Hours<10,
            append(VerifGames, [Game], AuxVerif)
        );
        AuxVerif = VerifGames
    ),
    fewHours(Player, AuxParsed, AuxVerif, Games).

fewHours(_, _, Games, Games).
    
ageRange(MinAge,MaxAge,Players):-
    findall(P, ( player(P,_,Age) , \+ ( Age < MinAge ; Age >MaxAge ) ), Players).

:- use_module(library(lists)).

averageAge(Game,AverageAge):-
    findall(Age, ( player(_,N,Age) , played(N,Game,_,_) ), Ages),
    sumlist(Ages, Sum),
    length(Ages,Div),
    AverageAge is Sum/Div.

buildList([],L,L).
buildList([P-N,P1-N1|R],L,Players):-
    P=:=P1,
    append(L,[N,N1],NL),
    buildList(R, NL, Players).

buildList([P-N,P1-N1|R],L,Players):-
    append(L,[N],Players).



mostEffectivePlayers(Game,Players):-
    findall(P-N, ( player(_,N,Age) , played(N,Game,H,Per),P is (Per/H) ), Percentage),
    sort(Percentage,Ordered),
    reverse(Ordered, UpOrder),
    buildList(UpOrder,[],Players),!.


excludeMirrors([],L,L).
excludeMirrors([R/Co|Re],L,Pairs):-
    (
        (
            member(R/Co,L)
            ;
            member(Co/R,L)
        ),excludeMirrors(Re,L,Pairs)
    );
    (
        append(L,[R/Co],NL),
        excludeMirrors(Re,NL,Pairs)
    ).

estaoLonge(MinDist,Matrix,Pairs):-
    findall(R/Co,(nth0(Row,Matrix,C),nth0(Col,C,Dist),Dist>=MinDist, R is Row+1,Co is Col+1),Pair),
    excludeMirrors(Pair,[],Pairs),!.

node(1, [2], [brasil]).
node(2, [3, 5], []).
node(3, [4], [irlanda]).
node(4, [], [niger, india]).
node(5, [6, 7], []).
node(6, [], [servia, franca]).
node(7, [8], [reinounido]).
node(8, [9], [australia]).
node(9, [10], [georgia]).
node(10, [], [santahelena,anguila]).

getParents(1,L,L).
getParents(N,L,PNodes):-
    findall(Pnode, (node(Pnode,L1,_),member(N,L1)),NL),
    NL=[NN],
    append(NL,L,NewPnodes),
    getParents(NN, NewPnodes, PNodes).

countdist([P1],[P1],Acc,Acc).
countdist([PL1|R],PL2,Acc,Dist):-
    NAcc is Acc+1,
    countdist(R,PL2,NAcc,Dist).



distance(Ob1,Ob2,Dist):-
    findall(N1,(node(N1,_,L1),member(Ob1,L1)),Node1),
    findall(N2,(node(N2,_,L2),member(Ob2,L2)),Node2),
    Node1=[ND1],Node2=[ND2],
    getParents(ND1,Node1,PN1), getParents(ND2,Node2,PN2),
    reverse(PN1,ParentsList1), reverse(PN2,ParentsList2),
    length(ParentsList1,Length1), length(ParentsList2,Length2),
    (
        (
            Length1>=Length2,
            countdist(ParentsList1,ParentsList2,1,Dist)
        );
        (
            Length2>Length1,
        countdist(ParentsList2,ParentsList1,1,Dist)
        )

    ).