:-consult('play.pl').
:-consult('display.pl').
:-consult('input.pl').
:-consult('utils.pl').
:-consult('logic.pl').
:-use_module(library(random)).
:-use_module(library(clpfd)).
:-use_module(library(lists)).

%Main function
%Calls the initial functions and the game's loop

play :-
    initial(GameState),
    display_game(GameState, Player),
    game_loop(GameState,'BLACKS').
