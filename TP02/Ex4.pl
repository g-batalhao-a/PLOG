factorial(0,1).
factorial(N,Valor):-
    New is N-1,
    factorial(New,Value),
    Valor is Value*N.

fibonacci(0,1).
fibonacci(1,1).
fibonacci(N,Valor):-
    N>1,
    First is N-1, fibonacci(First,Value1),
    Second is N-2, fibonacci(Second,Value2),
    Valor is Value1+Value2.