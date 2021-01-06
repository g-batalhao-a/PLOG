:-use_module(library(clpfd)).

/*
    Limonada-1
    guarana-2
    whisky-3
    vinho-4
    cham-5
    agua-6
    lara-7
    cafe-8
    cha-9
    ver-10
    cer-11
    vod-12
*/
camp:-
    Names=[Joao, Miguel, Nadia, Silvia, Afonso, Cristina, Geraldo, Julio, Maria, Maximo, Manuel , Ivone],
    domain(Names,1,12),
    all_distinct(Names),
    Geraldo#\=12 #/\ Geraldo#\=11 #/\ Geraldo#\=2  #/\ Geraldo#\=3  #/\ Geraldo#\=6 #/\ Geraldo#\=10 #/\ Geraldo#\=9 #/\ Geraldo#\=8 #/\ Geraldo#\=7 #/\ Geraldo#\=1,
    Julio#\=12  #/\ Julio#\=11  #/\ Julio#\=2  #/\ Julio#\=3  #/\ Julio#\=5  #/\ Julio#\=6 #/\ Julio#\=10 #/\ Julio#\=9 #/\ Julio#\=8 #/\ Julio#\=7 #/\ Julio#\=1,
    Maria#\=10  #/\ Maria#\=9  #/\ Maria#\=7  #/\ Maria#\=1 #/\ Maria#\=12 #/\ Maria#\=11 #/\ Maria#\=8 #/\ Maria#\=2  #/\ Maria#\=3,
    Maximo#\=10  #/\ Maximo#\=9  #/\ Maximo#\=6  #/\ Maximo#\=3 #/\ Maximo#\=2  #/\ Maximo#\=12 #/\ Maximo#\=11 #/\ Maximo#\=8 #/\ Maximo#\=7,
    Ivone#\=8  #/\ Ivone#\=7 #/\ Ivone#\=12 #/\ Ivone#\=11 #/\ Ivone#\=9 #/\ Ivone#\=8,
    Manuel#\=8 #/\ Manuel#\=7 #/\ Manuel#\=2 #/\ Manuel#\=12 #/\ Manuel#\=11 #/\ Manuel#\=9 #/\ Manuel#\=8,
    Joao#\=9 #/\ Joao#\=8 #/\ Joao#\=12 #/\ Joao#\=2  #/\ Joao#\=3 #/\ Joao#\=7  #/\ Joao#\=1#/\ Joao#\=6 ,
    Miguel#\=9 #/\ Miguel#\=8 #/\ Miguel#\=12 #/\ Miguel#\=2 #/\ Miguel#\=3 #/\ Miguel#\=7  #/\ Miguel#\=1 #/\ Miguel#\=5  #/\ Miguel#\=6,
    Nadia#\=7 #/\ Nadia#\=1 #/\ Nadia#\=9 #/\ Nadia#\=8 #/\ Nadia#\=2  #/\ Nadia#\=3,
    Silvia#\=9 #/\ Silvia#\=12 #/\ Silvia#\=8 #/\ Silvia#\=3 #/\ Silvia#\=6 #/\ Silvia#\=5 #/\ Silvia#\=2,
    Afonso#\=8 #/\ Afonso#\=6 #/\ Afonso#\=5 #/\ Afonso#\=2 #/\ Afonso#\=12 ,

    labeling([],Names),
    write(Names),fail.