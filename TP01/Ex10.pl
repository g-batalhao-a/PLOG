comprou(joao, honda).
ano(honda, 1997). 
comprou(joao, uno).
ano(uno, 1998).
valor(honda, 20000).
valor(uno, 7000). 

pode_vender(Pessoa,Carro,2020):-
    ano(Carro,AnoCarro),
    valor(Carro,ValorCarro),
    AnoCarro-2020 =:= 10,
    ValorCarro<10000.