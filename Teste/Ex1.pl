participant(1234, 17, 'Pé coxinho').
participant(3423, 21, 'Programar com os pés').
participant(3788, 20, 'Sing a Bit').
participant(4865, 22, 'Pontes de esparguete').
participant(8937, 19, 'Pontes de pen-drives').
participant(2564, 20, 'Moodle hack').

performance(1234,[120,120,120,120]).
performance(3423,[32,120,45,120]).
performance(3788,[110,2,6,43]).
performance(4865,[120,120,110,120]).
performance(8937,[97,101,105,110]).

madeItThrough(Participant):-
    performance(Participant,List),
    find(List,120).

find([H|T],Value):-
    H=:=Value;
    find(T,Value).

juriTimes(Participants, JuriMember, Times, Total):-
    jrTime(Participants, JuriMember, [], Times, 0,Total).

jrTime([], _, Times, Times, Total, Total).
jrTime([Participants|T], JuriMember, TList, Times, Acc, Total):-
    performance(Participants,List),
    getTime(List,JuriMember,Time),
    append(TList,[Time],NewT),
    NewAcc is Time+Acc,
    jrTime(T,JuriMember,NewT,Times,NewAcc,Total).
    

getTime([H|T],1,H).
getTime([H|T],JuriMember,Time):-
    N is JuriMember-1,
    getTime(T,N,Time).

patientJuri(JuriMember):-
    performance(P1,_),performance(P2,_), P1\=P2,
    juriTimes([P1,P2], JuriMember, Times, Total),
    isPatient(Times,2).

isPatient(_,0).
isPatient([],0).
isPatient([Times|T],Num):-
    (
        (
            Times=:=120,
            N is Num-1,
            isPatient(T,N)
        );
        (
            isPatient(T,Num)
        )
    ).

bestParticipant(P1, P2, P):-
    performance(P1,P1L),
    performance(P2,P2L),
    sumTime(P1L,0,P1S),
    sumTime(P2L,0,P2S),
    (
        (P1S<P2S,P=P2);
        (P2S<P1S,P=P1);
        fail
        ).


sumTime([],Sum,Sum).
sumTime([Time|T],Acc,Sum):-
    NewAcc is Acc+Time,
    sumTime(T,NewAcc,Sum).

allPerfs :-
    participant(P,_,Act),
    performance(P,L),
    write(P),write(':'),write(Act),write(':'),write(L),nl,
    fail.


nSuccessfulParticipants(T):-
    findall(P, (participant(P,_,_), performance(P,Times),noButton(Times)), L),
    length(L, T).

noButton([]).
noButton([Time|T]):-
    Time==120,
    noButton(T).

noButton([],L,L,_).
noButton([Time|T],Cop,L,Num):-
    (
        (
            Time==120,
            append(Cop,[Num],NewL),
            N is Num+1,
            noButton(T,NewL,L,N)
        );
        (
            N is Num+1,
            noButton(T,Cop,L,N)
        )
    ).

byPart([],PTL,PTL).
byPart([P-Times|T],Cop,PTL):-
    noButton(Times,[],L,1),
    append(Cop,[P-L],Next),
    byPart(T, Next, PTL).

juriFans(Li):-
    findall((P-L), (participant(P,_,_),performance(P,L)), List),
    byPart(List,[],PTL),
    Li=PTL.


:- use_module(library(lists)).

eligibleOutcome(Id,Perf,TT) :-
    performance(Id,Times),
    madeItThrough(Id),
    participant(Id,_,Perf),
    sumlist(Times,TT).

nextPhase(N, Participants):-
    findall((T-P-Perf),(participant(P,_,_),eligibleOutcome(P,Perf,T)),RL),
    elimina_duplicados(RL,L),
    length(L, Len),
    (
        (
            Len>=N,
            findall(E,(nth1(I,L,E), I=<N),FL),
            Participants=FL
        );
        fail
    ).

elimina_duplicados([X|L1],L2):-
    elim(L1,[X],L2).


search(H,[H|Cop]).
search(H,[X|Cop]):-search(H,Cop).

elim([],L2,L2).
elim([H|L1],Cop,L2):-
    (
        (
            search(H,Cop),
            elim(L1,Cop,L2)
        );
        (
            append(Cop,[H],NewCop),
            elim(L1,NewCop,L2)
        )
    ).

impoe(X,L) :-
    length(Mid,X),
    append(L1,[X|_],L), append(_,[X|Mid],L1).

distance(F,P,N):-
    P=<N,!,
    nth1(I,F,P),
    nth1(J,F,P),
    J is I+P+1, Q is P+1,
    distance(F,Q,N).

distance(_,_,_).
    

langford(N,L):-
    M is N*2,
    length(L,M),
    distance(L,1,N).