:-use_module(library(clpfd)).
:-use_module(library(lists)).

zebra(Zebra,Water):-
    Sol = [Colour,Nac,Drink,Brand,Ani],
    Colour = [Red,Yel,Blue,Gre,Whi],
    Nac = [Eng,Esp,Nor,Ucr,Port],
    Drink = [Juice,Tea,Cof,Milk,Water],
    Brand = [Marl,Chest,Win,Luky,SG],
    Ani = [Dog,Fox,Igu,Hor,Zebra],
    append(Sol, L),
    domain(L,1,5),
    all_distinct(Colour), all_distinct(Nac), all_distinct(Drink), all_distinct(Brand), all_distinct(Ani),
    Eng#=Red, Esp#=Dog,Nor#=1,Marl#=Yel, abs(Chest-Fox)#=1, abs(Nor-Blue)#=1,
    Win#=Igu,Luky#=Juice,Ucr#=Tea,Port#=SG,abs(Marl-Hor)#=1, Gre#=Cof,Gre#=Whi+1,Milk#=3,

    labeling([],L).
