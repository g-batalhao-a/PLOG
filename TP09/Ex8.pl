:-use_module(library(clpfd)).

/*
peixe-1
porco-2
pato-3
omlete-4
bife-5
esparguete-6
*/

restaurant:-
    Names=[Bernard, Daniel, Francisco, Henrique, Jaqueline, Luis],
    domain(Names,1,6),
    all_distinct(Names),

    Daniel#\=1,Jaqueline#\=1,
    Francisco#\=2 #/\ Francisco#\=3,
    Bernard#\=4 #/\ Bernard#\=3,
    Daniel#\=4 #/\ Daniel#\=3,
    Bernard#=2 #\/ Bernard#=5,
    Francisco#=5,
    Henrique#=2 #\/ Henrique#=3,

    labeling([],Names),
    write(Names),fail.