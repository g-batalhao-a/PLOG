:-use_module(library(clpfd)).

books:-
    Places=[A,B,C,D,E,F,G,H],
    domain(Places,0,100),

    A+B+C+D#=52, A+C#=27, B+D#=25,
    C+D+G+H#=34, D#=3,
    A+E+C+G#=46, A+E#=23, C+G#=23,
    F+H#=20,
    E+F#=31,
    
    labeling([],Places),
    write(Places),nl,
    Sum is A+B+C+D+E+F+G+H,
    write(Sum),fail.