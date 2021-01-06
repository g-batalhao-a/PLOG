:-use_module(library(clpfd)).

/*
    F - 1
    R - 2
    S - 3
    MF - 4
    MR - 5
    MS - 6

    Det -1
    Mid-2
    Chi-3

    10.000 - 1
    3x - 2

*/

maq:-
    Sol=[Name,Cities],
    Names=[Rev,Fog,Maq,P1,P2,P3],
    Cities=[CRev,CFog,CMaq,CP1,CP2,CP3],
    append(Sol,L),
    domain([Rev,Fog,Maq],1,3), domain([P1,P2,P3],4,6),
    domain(Cities,1,3),

    all_distinct(Name),
    CMR#=1,S\#=2.
