/*
1
2
3
4
5
6

*/

:-use_module(library(clpfd)).
:-use_module(library(lists)).

race:-
    Sol=[Nac,Marca],
    Nac=[AL,IN,BR,ES,IT,FR],
    Marca=[LVC1,LVC2,SV1,SV2,F1,F2],
    append(Sol,L),
    domain(Nac,1,6),
    all_distinct(Nac),
    domain(Marca,1,6),
    all_distinct(Marca),

    LVC1#=1,LVC2#=AL,
    SV1#=5,SV2#=BR,
    F1#=3,F2#=ES,

    ES#\=2, ES#\=6,
    IT#\=3, FR#\=3,
    AL#\=2, IT#\=1,

    labeling([],L),
    write(Sol),fail.     