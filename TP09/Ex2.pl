:-use_module(library(clpfd)).

/*
    Joao-1
    Ant-2
    Fran-3

*/


musicians:-
    Names=[Hapr,Viol,Pia],
    domain(Names,1,3),
    all_distinct(Names),

    Pia#\=2,
    Pia#\=1, 
    Viol#\=1,

    labeling([],Names),
    write(Names).