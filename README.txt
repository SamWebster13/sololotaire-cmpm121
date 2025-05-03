Solitaire
Samuel L. Webster
CMPM 121 – Game Development

Overview
This is a classic implementation of Solitaire built using the LÖVE2D framework. The game incorporates core mechanics such as card dragging, tableau stacking, foundation sorting, stock cycling, and win detection, offering players a familiar and fully functional Solitaire experience.

Features Added
Fully functional drag-and-drop card interaction.

Click-based card flipping and movement from stock to waste.

Correct stacking logic for tableau and foundations.

Win state detection and celebration.

Timer and step counter to track performance.

Attempted Undo functionality (not fully implemented due to time constraints).

Foundation cards now automatically snap to the center of their slots for clean visual alignment.

Programming Patterns
The project utilized several core design patterns:

Object-Oriented Programming (OOP): Central to the structure, with clear classes such as Card, Deck, Pile, Tableau, and Game to encapsulate behavior and state.

Observer Pattern: Changes in card state (flips, moves, etc.) automatically update the interface, streamlining game logic.

Command Pattern (attempted): Used for move tracking and intended to support undo functionality by storing previous game states and actions.

Postmortem
What Went Well:
The modular class structure made development organized and easy to expand.

Card interaction feels smooth and responsive.

Game state updates consistently across stock, waste, tableau, and foundation piles.

Visual presentation is clean, aided by well-aligned card placements and animated feedback.

Challenges:
Undo functionality was partially implemented but not completed due to limited time.

Some visual bugs (like initial card shadowing) required fine-tuning of coordinate math.

Overall, the game is feature-complete for core Solitaire play and has a strong foundation for further polish or additions.

Assets Used
Card Sprites: Kenney.nl Boardgame Pack