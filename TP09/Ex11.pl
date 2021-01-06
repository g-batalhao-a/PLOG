:-use_module(library(clpfd)).

/*
PP-1
F-2
A-3
R-4
T-5
V-6
*/

sports:-
    Names=[ Claudio, David, Domingos, Francisco, Marcelo, Paulo],
    domain(Names,1,6),
    all_distinct(Names),

    Marcelo#=2,
    Francisco#\=6,Paulo#\=6,
    Domingos#\=4,
    Claudio#\=3,Claudio#\=4, Francisco#\=3,Francisco#\=4,
    David#=5,

    labeling([],Names),
    write(Names),fail.