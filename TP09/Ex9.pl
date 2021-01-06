:-use_module(library(clpfd)).

ciclism:-
    Names=[Carlos, Ricardo, Raul, Tomas, Roberto, Boris, Diego, Luis],
    domain(Names,1,8),
    all_distinct(Names),

    Ricardo#\=7 #/\ Ricardo#\=3#/\ Ricardo#\=4#/\ Ricardo#\=1#/\ Ricardo#\=5,
    Boris#\=3#/\ Boris#\=4#/\ Boris#\=1#/\ Boris#\=5 #/\ Boris#\=7 #/\ Boris#\=8,
    Luis#=2,
    Roberto#\=5,
    Tomas#=1#\/Tomas#=2#\/Tomas#=3#\/Tomas#=4,
    Raul#\=4 #/\Tomas#\=4,
    Diego#\=7 #/\ Diego#\=8 ,
    Raul#\=5,
    Carlos#=1 #\/ Carlos#=2,

    labeling([],Names),
    write(Names),fail.
