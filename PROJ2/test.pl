
save_sizes:-
    size_test(X),
    format('~w\n', [X]),
    save(X),
    fail.

save_heuristics:-
    option_test(X),
    option_test_2(Y),
    option_test_3(Z),
    format('~w ~w ~w\n', [X, Y, Z]),
    save(5,X,Y,Z),
    fail.

size_test(6).
size_test(5).
size_test(4).
size_test(3).
size_test(2).

option_test(leftmost).
option_test(min).
option_test(max).
option_test(ff).
option_test(anti_first_fail).
option_test(occurrence).
option_test(ffc).
option_test(max_regret).

option_test_2(step).
option_test_2(enum).
option_test_2(bisect).
option_test_2(median).
option_test_2(middle).

option_test_3(up).
option_test_3(down).

save(N):-
    Predicate =.. [run, N],
    file_name(N,FileName),
    format('Saving to ~w\n', [FileName]),
    open(FileName, write, S1),
    current_output(Console),
    set_output(S1),
    statistics(runtime, [T0|_]),
    (Predicate ; true),
    statistics(runtime, [T1|_]),
    T is T1 - T0,
    format('~w took ~3d sec.~n', [Predicate, T]),
    close(S1),
    set_output(Console),
    format('~w took ~3d sec.~n', [Predicate, T]).

% save de 6 argumentos para guardar resultados de heuristica
save(N, X, Y, Z):-
    Predicate =.. [run, N, X, Y, Z],
    file_name(N, X, Y, Z, FileName),
    format('Saving to ~w\n', [FileName]),
    open(FileName, write, S1),
    current_output(Console),
    set_output(S1),
    statistics(runtime, [T0|_]),
    (Predicate ; true),
    statistics(runtime, [T1|_]),
    T is T1 - T0,
    format('~w took ~3d sec.~n', [Predicate, T]),
    close(S1),
    set_output(Console),
    format('~w took ~3d sec.~n', [Predicate, T]).

% buscar todas as configurações para um dado numero de Tips, dependendo de Cut e Restrições nos Operadores
run(N):-
    solver(N,L),
    fail.

run(N, X, Y, Z):-
    solver(N,L,X,Y,Z),
    fail.

file_name(N, FileName):-
    number_chars(N, CharList),
    atom_chars(Atom, CharList),
    atom_concat(Atom, '_rows', Temp),
    atom_concat(Temp, '.txt', FileName).

file_name(N, X, Y, Z, FileName):-
    number_chars(N, CharList),
    atom_chars(Atom, CharList),
    atom_concat(Atom, '_rows_', Temp),
    atom_concat(Temp, '_', Temp2),
    atom_concat(Temp2, X, Temp3),
    atom_concat(Temp3, '_', Temp4),
    atom_concat(Temp4, Y, Temp5),
    atom_concat(Temp5, '_', Temp6),
    atom_concat(Temp6, Z, Temp7),
    atom_concat(Temp7, '.txt', FileName).
