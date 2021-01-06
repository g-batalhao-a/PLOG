:-use_module(library(clpfd)).

liquidordust:-
    People=[A,B,U,T],
    domain(People,0,10000),

    T#=A+B+427+U,
    T#=5*U,
    2*T#=15*B,
    3*T#=35*A,

    labeling([],People),
    write(People),fail.