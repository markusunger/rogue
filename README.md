# An unnamed Roguelike

### Installation 

- clone the repo
- `bundle install`
- `ruby rogue.rb`
- navigate to `localhost:4567`

### Overview

You control the `@` symbol. On each floor, enemies (varying red symbols) wait and must be defeated. To climb down to another floor, move to the exit stairs (`¬`). After you successfully passed floor 10, you win the game. If you die, you have to start over.

### Instructions

Use the `WASD` keys to move in straight lines and `QEYC` to move diagonally.

In order to attack enemies, you have two possibilities: 
- move directly into them for a weak basic attack
- use one of your skills


You have five skill slots, identified by the keys `1` to `5`. To use a skill, press the corresponding key as indicated in the UI. Depending on what the skill does, you have to select a valid target next. Skills that target specific enemies mark each enemy in range with a number. Press that number key to execute the skill effect.
If the skill targets the player itself, just confirm with the skill hotkey again (or use any other key, it doesn't matter).