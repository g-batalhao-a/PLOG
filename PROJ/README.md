# PLOG 2020/2021 - TP1

## Group: T3_Greener3

| Name             | Number    | E-Mail                |
| ---------------- | --------- | --------------------- |
| António Bezerra    | 201806854 | up201806854@fe.up.pt  |
| Gonçalo Alves    | 201806451 | up201806451@fe.up.pt  |

## Instalation and Execution

To run our game follow the following steps:

- Install and run SICStus Prolog.
- Go to File > Working Directory and navigate to the *src* folder where you downloaded the code.
- Go to File > Consult and select the file *greener.pl*.
- **Alternatively:** run `consult('path\to\greener.pl').`
- Type `play.` into the SICStus console and the game will start.

## Greener

Greener is the second game of the Green-Greener-Greenest set. Green, Greener and Greenest are three games that use the same set of components, based on pyramid shaped pieces of three colors: white, black and green.

Greener is a capturing game for 2 players, where both must capture the green pieces on the board.

The game board can be configured in three different ways:

- Basic: a 6×6 board with 9 black pyramids, 18 green pyramids and 9 white pyramids.
- Intermediate: a 6x9 board with 18 black pyramids, 18 green pyramids and 18 white pyramids.
- Advanced: a 9×9 board with 27 black pyramids, 27 green pyramids and 27 white pyramids.

Gameplay overview:

- The board starts full with randomly placed pyramids.
- Players can move pieces of their color or stacks of pieces with a piece of their own color on top.
- The pieces or stacks can only be moved orthagonally and placed on top of another stack if there are no stacks in between.
- The player can capture a stack of any color.
- The player must capture a stack if possible. When no captures are possible the turn is **passed**.
- The game ends when both players pass their turn.
- The winner is the player that captures the most green pieces. In case of a tie, the player with the highest stack wins. If the tie persists, play again.

[Source](https://www.boardgamegeek.com/boardgame/227145/greengreenergreenest)

[Rules](https://nestorgames.com/rulebooks/GREENGREENERGREENEST_EN.pdf)

## Game Logic

### Game state representation

#### Board

To represent our board matrix we use a list of lists.

Since our cells will hold stacks of pieces, each cell is also a list, that will hold the pieces in it's stack, in top-down order.

Each piece is represented by a string that specifies the color: white, green or black. Empty cells are represented by a list that contains a single string: empty.

Below are examples of a board representation during the course of a game:

- Initial Situation:

```
    [
    [[black],[green],[black],[white],[green],[black]],
    [[black],[green],[green],[white],[white],[black]],
    [[green],[green],[black],[green],[black],[green]],
    [[black],[green],[white],[green],[black],[white]],
    [[green],[white],[white],[white],[white],[green]],
    [[green],[green],[green],[green],[green],[green]]
    ]
```

- Intermediate Situation:

```
    [
    [[black],[green],[black],[white],[green],[empty]],
    [[black],[black,green,green],[empty],[empty],[white],[empty]],
    [[green],[green],[empty],[empty],[empty],[empty]],
    [[black],[green],[white],[white,white,white,black,white,black,green,white,green,black,green,green,green,black,green,green],[empty],[empty]],
    [[green],[white],[empty],[empty],[empty],[empty]],
    [[green],[green],[green],[empty],[empty],[empty]]
    ]
```  

- Final Situation:

```
    [
    [[empty],[empty],[empty],[empty],[empty],[empty]],
    [[empty],[empty],[empty],[empty],[empty],[empty]],
    [[white,black,white,white,white,white,white,black,white,black,green,white,green,black,green,green,green,black,green,green,green,black,white,black,black,green,green,black,green,green,green,green,green,green,green,green],[empty],[empty],[empty],[empty],[empty]],
    [[empty],[empty],[empty],[empty],[empty],[empty]],
    [[empty],[empty],[empty],[empty],[empty],[empty]],
    [[empty],[empty],[empty],[empty],[empty],[empty]]
    ]
```

#### Player

As for the players, we simply have a string representing each one: BLACKS and WHITES.
To distinguish between a human and a computer player, we also use a flag string with the values H or C, respectively.

### GameState Visualization

#### Board

The board is displayed using the predicate `printBoard(GameState)` that calls other predicates: 
- `printHeader` - prints an indication of what the values in the cells mean.
- `printNumberHeader(0,NumCols)` - prints the label of the columns, starting from 0.
- `printDivider(0,NumCols)` - prints a separator line.
- `printMatrix(X, 0,NumRows,NumCols)` - prints the game board itself.

The `printMatrix` predicate in turn, calls other predicates:
- `letter(Index,Letter)` - translates a list index into a letter, for labeling each row, that is later printed.
- `printExtraLine(0,NumCols)` - prints a blank line with column separators, for a more appealing appearence.
- `printLine(Line)` - prints a row of cells.
- `printMatrix(Tail, N1,NumRows,NumCols)` - recursive call to print the following rows.

The `printLine` predicate calls `printCell` with the first element of the row list and recursively calls printLine to print all cells.

`printCell` calls `symbol(Value, Symbol)` to map the color of the piece on top of the stack (if any) to the symbols **X** (black), **O** (white), **G** (green). Empty cells have no symbol. Followed by the number of green pieces in the stack, obtained using `countPoints(+Cell, -Points)`.

Below are the visualizations for the game states showed in the [GameState Representation](#Board):

- Initial Situation:

```
      0     1     2     3     4     5
   +-----+-----+-----+-----+-----+-----+
   |     |     |     |     |     |     |     
 A | X/0 | G/1 | X/0 | O/0 | G/1 | X/0 | 
   |     |     |     |     |     |     |     
   +-----+-----+-----+-----+-----+-----+
   |     |     |     |     |     |     |     
 B | X/0 | G/1 | G/1 | O/0 | O/0 | X/0 | 
   |     |     |     |     |     |     |     
   +-----+-----+-----+-----+-----+-----+
   |     |     |     |     |     |     |     
 C | G/1 | G/1 | X/0 | G/1 | X/0 | G/1 | 
   |     |     |     |     |     |     |     
   +-----+-----+-----+-----+-----+-----+
   |     |     |     |     |     |     |     
 D | X/0 | G/1 | O/0 | G/1 | X/0 | O/0 | 
   |     |     |     |     |     |     |     
   +-----+-----+-----+-----+-----+-----+
   |     |     |     |     |     |     |     
 E | G/1 | O/0 | O/0 | O/0 | O/0 | G/1 | 
   |     |     |     |     |     |     |     
   +-----+-----+-----+-----+-----+-----+
   |     |     |     |     |     |     |     
 F | G/1 | G/1 | G/1 | G/1 | G/1 | G/1 | 
   |     |     |     |     |     |     |     
   +-----+-----+-----+-----+-----+-----+
```

- Intermediate Situation:

``` 
      0     1     2     3     4     5
   +-----+-----+-----+-----+-----+-----+
   |     |     |     |     |     |     |     
 A | X/0 | G/1 | X/0 | O/0 | G/1 |  /0 | 
   |     |     |     |     |     |     |     
   +-----+-----+-----+-----+-----+-----+
   |     |     |     |     |     |     |     
 B | X/0 | X/2 |  /0 |  /0 | O/0 |  /0 | 
   |     |     |     |     |     |     |     
   +-----+-----+-----+-----+-----+-----+
   |     |     |     |     |     |     |     
 C | G/1 | G/1 |  /0 |  /0 |  /0 |  /0 | 
   |     |     |     |     |     |     |     
   +-----+-----+-----+-----+-----+-----+
   |     |     |     |     |     |     |     
 D | X/0 | G/1 | O/0 | O/7 |  /0 |  /0 | 
   |     |     |     |     |     |     |     
   +-----+-----+-----+-----+-----+-----+
   |     |     |     |     |     |     |     
 E | G/1 | O/0 |  /0 |  /0 |  /0 |  /0 | 
   |     |     |     |     |     |     |     
   +-----+-----+-----+-----+-----+-----+
   |     |     |     |     |     |     |     
 F | G/1 | G/1 | G/1 |  /0 |  /0 |  /0 | 
   |     |     |     |     |     |     |     
   +-----+-----+-----+-----+-----+-----+
```

- Final Situation:

```
      0     1     2     3     4     5
   +-----+-----+-----+-----+-----+-----+
   |     |     |     |     |     |     |     
 A |  /0 |  /0 |  /0 |  /0 |  /0 |  /0 | 
   |     |     |     |     |     |     |     
   +-----+-----+-----+-----+-----+-----+
   |     |     |     |     |     |     |     
 B |  /0 |  /0 |  /0 |  /0 |  /0 |  /0 | 
   |     |     |     |     |     |     |     
   +-----+-----+-----+-----+-----+-----+
   |     |     |     |     |     |     |     
 C | O/18 |  /0 |  /0 |  /0 |  /0 |  /0 | 
   |     |     |     |     |     |     | 
   +-----+-----+-----+-----+-----+-----+
   |     |     |     |     |     |     |     
 D |  /0 |  /0 |  /0 |  /0 |  /0 |  /0 | 
   |     |     |     |     |     |     |     
   +-----+-----+-----+-----+-----+-----+
   |     |     |     |     |     |     |     
 E |  /0 |  /0 |  /0 |  /0 |  /0 |  /0 | 
   |     |     |     |     |     |     |     
   +-----+-----+-----+-----+-----+-----+
   |     |     |     |     |     |     |     
 F |  /0 |  /0 |  /0 |  /0 |  /0 |  /0 | 
   |     |     |     |     |     |     |     
   +-----+-----+-----+-----+-----+-----+
```

#### Menus

When a user runs the program, they are presented with the main menu, where they select the game mode they want to play:

- Player vs Player - two human players
- Player vs Computer - human plays first
- Computer vs Player - computer plays first
- Computer vs Computers - two computer players

![Main Menu](img/main_menu.png)

After selecting a game mode, the user must select the board size to be used:

![Board Size](img/board_size.png)

After that, when a computer is playing, the user must select the level of difficulty of the artificial inteligence:

![AI Level](img/AI_level.png)

#### Input validation

To prevent unexpected behavior upon invalid user inputs, we implemented robust user input validation that warns the user when the input was not valid and asks for a new try.

##### Menu input validation

In the case of menus, the input is invalid if it is out of the range of menu options or of a different type.

Each menu has an input validation predicate (`readMenuOption`, `readSizeOption`, `readDifficultyOption`) that handles calling the predicate `checkMenuOption(Option,NumOptions,SelOption)`. This predicate is given the option key code, that is mapped to an option number using `menuOption(Option, Selection)`. If the code is not a valid menu option or exceeds the number of menu options of the specific menu, the predicate fails and asks for a new option. If the option is valid, it is returned in *SelOption*.

![Menu Invalid Input](img/invalid_menu.png)

##### Gameplay input validation

As for gameplay input validation, the program checks not only if the selection is a valid row/column in the board, but also if it represents a valid move according to the rules.

For detecting invalid row and column inputs, the predicates `validateRow` and `validateColumn`. These map the code input in the console to a row/column number (using predicates `row` and `column`) and check if it is within the bounds of the current board.

The code supporting this validation is integrated in the `move(GameState,PieceAndMove,FinalMoveGameState)` predicate. Validating input with regards to the game rules will be detailed in the [Move execution](#Move-execution) section of the report.

- Invalid row/column - player inserts invalid/out of bounds values for row and column

![Invalid Row Column](img/invalid_row_column.png)

- Invalid piece selection - player tries to select piece of a color diferent from his

![Invalid Selection](img/invalid_selection.png)

- Invalid capture - player tries to capture unreachable stack

![Invalid Capture](img/invalid_capture.png)

### List of valid moves

To get the list of possible moves given the current board state and player we implemented the `valid_moves(GameState, Player,ListOfMoves)` predicate. This predicate first gets the board dimensions and then calls `iterateMatrix(GameState, NumRows, NumCols, Player, ListOfMoves)`.

The `iterateMatrix` predicate iterates over the board rows and calls predicate `findPiece` for each. This predicate iterates over each row and finds cells that contain stacks topped by pieces that match the color of the player. For each of these cells, it calls `checkNeighbours` to check the possible capturing moves.

The `checkNeighbours` predicate calls four helper predicates (`checkDown`, `checkUp`, `checkLeft`, `checkRight`) that check for possible captures in the orthogonal directions. These iterate over a column or row in a specific direction, starting from a specific cell. They stop when they reach the first non-empty cell and add the cell coordinates to a return list. When the predicate reaches the edge of the board without finding any non-empty cell, it returns an empty list.

The results of the predicates are then agreggated in a list of lists, each of which starts with the coordinates of a piece followed by the coordinates of all the valid positions it can move to.

### Move execution

Move execution is handled by the `move(GameState,PieceAndMove,FinalMoveGameState)` predicate. Since a move can be divided into two parts - selecting a stack to move and selecting a stack to capture - this calls upon two other predicates to validate and execute each one: `selectPiece` and `movePiece`, respectively.

`selectPiece` uses `readInputs` to read and validate a cell selection, using the validation criteria detailed in [Gameplay input validation](#Gameplay-input-validation). After selecting a valid cell of the board, the predicate then calls `validateContent` to check if the selection is valid according to the rules of the game.

To do this, `validateContent` recieves the list of possible moves and checks if there are moves that start with the selected piece. This means this predicate not only inhibits the player from selecting a piece that is not of their own color, but also from selecting pieces that do not have valid capture possibilities. The predicate then returns the index of the piece in the valid moves list, so that the capture validation function can check it right away.

`movePiece` uses the same predicates to validate a cell selection and then calls `validateCapture` to verify if the player is moving the piece to a valid position. This predicate does this by iterating the list of possible moves starting from the previously selected piece. If it finds the captured cell, the move is valid and it merges the cells' stacks, setting the source cell's one to empty. If not, the game asks the player to redo the move.

### End game state

### Board evaluation

### Computer move

## Conclusions

## Bibliography
