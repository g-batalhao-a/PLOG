:-consult('play.pl').
:-consult('display.pl').
:-consult('input.pl').
:-consult('utils.pl').
:-consult('logic.pl').
:-consult('bot.pl').
:-use_module(library(random)).
:-use_module(library(clpfd)).
:-use_module(library(lists)).
:-use_module(library(system)).

%Main function
%Calls the initial functions

play :-
    now(X),
    setrand(X),    
    printMainMenu,
    readMenuOption.
