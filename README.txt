Solitaire – CMPM 121 Final Project
By Samuel L. Webster

**Overview**
This is a complete implementation of Klondike Solitaire using Lua and LÖVE2D. The project was developed with a focus on clean code structure, responsive card interaction, and accurate game mechanics. The game includes all core systems expected in a functioning Solitaire game, along with extra polish such as animations, snapping, and undo functionality.

-**Core Features**
Drag & Drop Card Movement
Cards can be clicked and dragged between tableau piles, foundations, or returned to the stock. Movements are validated in real-time based on Solitaire rules.

-**Valid Placement Checking**
Card stacking enforces standard Klondike rules: red-on-black or black-on-red, descending in the tableau, ascending in suit in foundations.

-**Undo Functionality**
A fully functional Undo system was implemented using a simple Command Pattern approach. Every card move is tracked and reversible with a single click.

-**Timer and Step Counter**
Real-time display of elapsed playtime and number of moves made.

-**Win State Detection**
The game detects when all cards have been moved to the foundation piles, ending the session cleanly.

**Code Structure**
main.lua: Entry point, handles game loop and input.

Game.lua: Manages overall game state, UI, piles, and rules.

Card.lua: Represents individual cards, handles drawing and movement.

Deck.lua: Handles shuffling and card generation.

Tableau.lua: Abstract base class for stock, tableau, and foundation piles.

Design Patterns Used
Object-Oriented Programming (OOP): Encapsulation through Lua tables and metatables.

Command Pattern: Used for tracking reversible actions (Undo).

Separation of Concerns: Drawing, input, logic, and state are cleanly separated across classes.

Assets
Card Art & Icons: From Kenney.nl Boardgame Pack

