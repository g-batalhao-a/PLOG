e_primo(2).
e_primo(3).
e_primo(N):-
    N>3,
    N mod 2 =\= 0,
    \+ factor(N,3).

factor(N,F):-
    N mod F =:= 0.

factor(N,F):-
    F*F<N,
    F2 is F+2,
    factor(N,F2).