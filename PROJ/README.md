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


## Representação interna do estado do jogo

- Situação Inicial:

-   initialBoard([  
    [empty,empty,empty,empty,empty,empty],  
    [empty,empty,empty,empty,empty,empty],  
    [empty,empty,empty,empty,empty,empty],  
    [empty,empty,empty,empty,empty,empty],  
    [empty,empty,empty,empty,empty,empty],  
    [empty,empty,empty,empty,empty,empty]  
    ]).  

{}

        | 1 | 2 | 3 | 4 | 5 | 6 |  
     ---|---+---+---+---+---+---|  
      A |   |   |   |   |   |   |  
     ---|---+---+---+---+---+---|  
      B |   |   |   |   |   |   |  
     ---|---+---+---+---+---+---|  
      C |   |   |   |   |   |   |  
     ---|---+---+---+---+---+---|  
      D |   |   |   |   |   |   |  
     ---|---+---+---+---+---+---|  
      E |   |   |   |   |   |   |  
     ---|---+---+---+---+---+---|  
      F |   |   |   |   |   |   |  
     ---|---+---+---+---+---+---|  


- Situação Intermédia:

-   midBoard([  
    [red,empty,black,empty,black,empty],  
    [empty,empty,empty,empty,empty,empty],  
    [black,empty,empty,red,empty,empty],  
    [empty,empty,empty,empty,empty,black],  
    [empty,red,empty,empty,empty,empty],  
    [empty,empty,empty,empty,red,empty]  
    ]).
  
{}  
   
        | 1 | 2 | 3 | 4 | 5 | 6 |  
     ---|---+---+---+---+---+---|  
      A | O |   | X |   | X |   |  
     ---|---+---+---+---+---+---|  
      B |   |   |   |   |   |   |  
     ---|---+---+---+---+---+---|  
      C | X |   |   | O |   |   |  
     ---|---+---+---+---+---+---|  
      D |   |   |   |   |   | X |  
     ---|---+---+---+---+---+---|  
      E |   | O |   |   |   |   |  
     ---|---+---+---+---+---+---|  
      F |   |   |   |   | O |   |  
     ---|---+---+---+---+---+---|  


- Situação Final:

-   finalBoard([  
    [empty,empty,empty,red,empty,empty],  
    [empty,empty,empty,empty,empty,empty],  
    [empty,black,empty,empty,red,empty],  
    [empty,empty,black,empty,empty,empty],  
    [red,empty,empty,black,empty,empty],  
    [empty,empty,empty,empty,empty,red]  
    ]).
  
{}  

        | 1 | 2 | 3 | 4 | 5 | 6 |  
     ---|---+---+---+---+---+---|  
      A |   |   |   | O |   |   |  
     ---|---+---+---+---+---+---|  
      B |   |   |   |   |   |   |  
     ---|---+---+---+---+---+---|  
      C |   | X |   |   | O |   |  
     ---|---+---+---+---+---+---|  
      D |   |   | X |   |   |   |  
     ---|---+---+---+---+---+---|  
      E | O |   |   | X |   |   |  
     ---|---+---+---+---+---+---|  
      F |   |   |   |   |   | O |  
     ---|---+---+---+---+---+---|