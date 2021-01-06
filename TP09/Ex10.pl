/*
130-arm
135-bara
65-comp
200 total
30 - nas 3

100-arm
105-bara
35-comp
170 total
*/

:-use_module(library(clpfd)).

meeting:-
    Single=[A,B,C,X,Y,Z],
    domain(Single,1,105),
    
    A+X+Y#=100, B+Y+Z#=105, C+X+Z#=35,
    100-A-Y#=35-Z-C, 100-A-X#=105-B-Z, 105-B-Y#=35-X-C,
    A+B+C+X+Y+Z#=170,

    labeling([],Single),
    Sum is A+B+C,
    write(Sum),nl,fail.