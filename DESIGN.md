#### Stoneflower Harvest
### Design Document

Stoneflower Harvest is a game created for the 12th Godot Wild Jam.  It is based on the following theme:

 > Pick at least 2 out of the 3 words below. You may use all 3 if you wish, but you must use at least 2.
 >
 > Chain | Destruction | Harvest

As the annual Golemburg Stoneflower Festival approaches, you must harvest stoneflowers for the town... with EXPLOSIONS!  Chain together bundles of dynamite in the most efficient way possible to get the most stoneflowers for your neighbors to feast on.

## Gameplay

This is a graph-basesd puzzle game in which players connect patches of flowers (nodes) with detonation cord (edges).  The goal is to connect all nodes using the shortest length of edges.  To connect two nodes, the player can click and drag from one node to another, or click one node then a second.

When the player thinks they have solved the puzzle, they press the plunger icon to try it.  If their solution is correct, each node will show a small explosion and an upbeat sound effect plays.  If their solution is incorrect, a disappointing sound plays and the player must wait a few seconds before trying again.

Players can either play a casual mode, which has no additional obstacles or goals, or timed mode where the player has a fixed amount of time to complete as many levels as possible.

## User Interface

The UI should be unobstrusive to allow maximum space on the screen for the actual puzzle.

 * Plunger icon (bottom left):  The user interacts with this icon to submit their solution for the level.
 * Remaining cord label (top left):  This shows how much detonation cord is left for the user to lay on this level.
 * Timer (top center):  On timed mode only, this shows how much time is remaining.
 * Mode icons (top right):  These switch between placing mode and erasing mode.  A spool of wires icon indicates placing mode.  An eraser icon indicated erasing mode.

During the tutorial two additional elements appear:
 
 * Text box (bottom third):  This box contains text explaining the game to the player
 * Character (bottom right):  This golem character points toward UI elements discussed in the text box and gives players encouragement.

## Theme and Graphics

The overall tone of the game is light-hearted and earthy.  The art style is bold cartoon-y, reminiscent of early Plants Vs Zombies games.  Because the game is based around the idea of golems eating stone foods, the UI elements and fonts will have a chisled-rock appearance.  Background music will be heavy on low woodwind instruments and percussion.
