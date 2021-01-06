:-use_module(library(clpfd)).

magicalhex:-
    List=[A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S],
    domain(List,1,19),
    all_distinct(List),
    A#>Q,H#>L,A#>L,C#>H,
    A+B+C#=D+E+F+G,D+E+F+G#=H+I+J+K+L,
    H+I+J+K+L#=M+N+O+P,M+N+O+P#=Q+R+S,
    A+B+C#=A+D+H,
    A+D+H#=B+E+I+M,B+E+I+M#=C+F+J+N+Q,
    C+F+J+N+Q#=G+K+O+R,G+K+O+R#=L+P+S,
    L+P+S#=C+G+L,C+G+L#=B+F+K+P,
    B+F+K+P#=A+E+J+O+S,A+E+J+O+S#=D+I+N+R,
    D+I+N+R#=H+M+Q,H+M+Q#=38,
    labeling([],List),
    write(List),fail.