:-use_module(library(clpfd)).

houses(N):-
    length(Houses, N),
    domain(Houses,1,N),
    element(N,Houses,6),
    all_distinct(Houses),
    times(Houses,Time),
    labeling([maximize(Time)], Houses),
    write(Houses).

times([_],0).
times([A,B|T],Time):-
    Time #= Time2 + abs(B-A),
    times([B|T],Time2).
