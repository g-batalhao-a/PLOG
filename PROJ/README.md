# PLOG 2020/2021 - TP1

## Group: T03G0?

| Name             | Number    | E-Mail                |
| ---------------- | --------- | --------------------- |
| António Bezerra    | 201806854 | up201806854@fe.up.pt  |
| Gonçalo Alves    | 201806451 | up201806451@fe.up.pt  |

## Greener

Greener is the second game of the Green-Greener-Greenest set. Green, Greener and Greenest are three games that use the same set of components.
Greener is a capturing game for 2 players, where both must capture the same colour.
Depending on the set, you’d have:

- Basic: a 6×6 board, 15 black pyramids, 20 green pyramids, 15 white pyramids.
- Advanced: a 6×9 – 9×9 board (using one or both pads), 30 black pyramids, 45 green pyramids, 30 white pyramids.

Gameplay overview:

- The board starts full of pyramids. Players take turns capturing pyramids or stacks of any colour orthogonally.
- The game ends when all players pass in succession. The player with the most green pyramids captured (being part of stacks they control) wins the game. In case of a tie, the player with the highest stack wins. If the tie persists, play again.

[Source](https://www.boardgamegeek.com/boardgame/227145/greengreenergreenest)
[Rules](https://nestorgames.com/rulebooks/GREENGREENERGREENEST_EN.pdf)


## Internal representation of the GameState

- Initial Situation:

```
   initialBoard([
    [white,green,green,white,green,black],
    [black,green,green,green,white,white],
    [green,white,white,green,black,black],
    [green,black,black,green,green,green],
    [black,green,green,white,black,green],
    [green,white,black,green,white,green]
    ]). 
```
       | 0 | 1 | 2 | 3 | 4 | 5 |
    ---|---|---|---|---|---|---|
     A | O | G | G | O | G | X | 
    ---|---|---|---|---|---|---|
     B | X | G | G | G | O | O | 
    ---|---|---|---|---|---|---|
     C | G | O | O | G | X | X | 
    ---|---|---|---|---|---|---|
     D | G | X | X | G | G | G | 
    ---|---|---|---|---|---|---|
     E | X | G | G | O | X | G | 
    ---|---|---|---|---|---|---|
     F | G | O | X | G | O | G | 
    ---|---|---|---|---|---|---|


- Intermediate Situation:

```
    midBoard([  
    [empty,empty,black,green,black,empty],  
    [empty,empty,empty,empty,empty,empty],  
    [white,green,empty,black,empty,empty],  
    [empty,empty,empty,empty,white,black],  
    [empty,black,empty,empty,empty,empty],  
    [empty,empty,empty,empty,white,empty]  
    ]).
```  
   
        | 1 | 2 | 3 | 4 | 5 | 6 |  
     ---|---|---|---|---|---|---|  
      A |   |   | X | G | X |   |  
     ---|---|---|---|---|---|---|  
      B |   |   |   | O | G | X |  
     ---|---|---|---|---|---|---|  
      C | O | G |   | X |   |   |  
     ---|---|---|---|---|---|---|  
      D |   |   |   |   | O | X |  
     ---|---|---|---|---|---|---|  
      E |   | X | O |   |   |   |  
     ---|---|---|---|---|---|---|  
      F | O |   |   |   | O |   |  
     ---|---|---|---|---|---|---|  


- Final Situation:

```
  finalBoard([  
    [empty,empty,empty,black,empty,empty],  
    [empty,empty,empty,empty,empty,empty],  
    [empty,white,empty,empty,black,empty],  
    [empty,empty,empty,empty,empty,empty],  
    [white,empty,empty,black,empty,empty],  
    [empty,empty,empty,empty,empty,white]  
    ]).
``` 

        | 1 | 2 | 3 | 4 | 5 | 6 |  
     ---|---|---|---|---|---|---|  
      A |   |   |   | X |   |   |  
     ---|---|---|---|---|---|---|  
      B |   |   |   |   |   |   |  
     ---|---|---|---|---|---|---|  
      C |   | O |   |   | X |   |  
     ---|---|---|---|---|---|---|  
      D |   |   |   |   |   |   |  
     ---|---|---|---|---|---|---|  
      E | O |   |   | X |   |   |  
     ---|---|---|---|---|---|---|  
      F |   |   |   |   |   | O |  
     ---|---|---|---|---|---|---|

### TO-DO:

- [X] Fix movement bug (currently moving in diagonals);
- [X]  Figure out how to store points (associate to Player, to Piece?...);
- [X]  Figure out how to store stack of pieces (if we want to store it in a piece; 
Head-Piece & Tail-Captured Pieces, must change display and replace functions);
- [X] (For now)  Function to check if there is a possible capture (check every piece before turn and see if there is a value diferent than empty next to it ?);
- [ ]  Function to count points and, if necessary, count length of stack and decide who wins;
- [ ]  Menu, for easier access and to choose size of board maybe;
- [ ] Fix replace empty bug, instead of replacing cell list with ['empty'] it's putting ['empty','black'];
