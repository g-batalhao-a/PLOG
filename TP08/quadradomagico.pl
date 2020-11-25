:-use_module(library(clpfd)).

quad_mag(S,L):-
    % Posição representa a casa, valor é o valor
    L = [A, B, C, D, E, F, G, H, I],
    domain(L, 1, 9),
    all_distinct(L),
    A + B + C #= S,  A + D + G #= S,
    D + E + F #= S,  B + E + H #= S,
    G + H + I #= S,  C + F + I #= S,
    A + E + I #= S, C + E + G #= S,
    A #< C, A #< G, C #<G,
    labeling([], L).