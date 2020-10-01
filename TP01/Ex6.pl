type(tweety,bird).
type(goldie,fish).
type(molie,worm).
type(sylvester, cat).
type(me, human).

likes(bird,worm).
likes(cat,fish).
likes(cat, bird).
likes(cat, human).
likes(human,cat).


eat(X,Y):-likes(Z,W),type(X,Z),type(Y,W).