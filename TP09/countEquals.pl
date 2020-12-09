:-use_module(library(clpfd)).

count_equals(_, [], 0).
count_equals(Val, [H|T], Count) :-
    Val #= H #<=> B,
    Count #= Count1 + B,
    count_equals(Val, T, Count1).