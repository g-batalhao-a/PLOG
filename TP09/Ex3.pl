:-use_module(library(clpfd)).

/*
livro-1
vestido-2
bolsa-3
gravata-4
chapeu-5
candeeiro-6
*/

mall:-
    Names=[Adams,Baker,Catt,Dodge,Ennis,Fisk],
    Floor=[BookF,DressF,BagF,TieF,HatF,LampF],
    domain(Names,1,6),
    domain(Floor,1,6),
    all_distinct(Names),

    Adams#=1,Ennis#=6,Catt#=3,Baker#\=4,
    BookF#=1,BagF#=2#/\TieF#=2,DressF#=3,LampF#=6, HatF#\=4,


    labeling([],Names),
    write(Names).
