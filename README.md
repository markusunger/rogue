# A Dungeon Forgotten

_A Dungeon Forgotten_ is a [rogue-like](https://en.wikipedia.org/wiki/Roguelike)-inspired game with a Ruby + Sinatra backend and some light HTML/CSS/JS frontend. The project's scope was mainly influenced by the amount of time I could dedicate to it. Since this is just a christmas side project, don't expect mind-bending architecture choices or lots of features.

### Installation 

- clone the repo
- `bundle install`
- `ruby rogue.rb`
- navigate to `localhost:4567`

### Overview

You control the `@` symbol. On each floor, enemies (varying red symbols) wait and must be defeated. To climb down to another floor, defeat all enemies and move to the exit stairs (`¬`). After you successfully passed floor 10, you win the game. If you die, you have to start over.

### Instructions

Use the `WASD` keys to move in straight lines and `QEYC` to move diagonally.

In order to attack enemies, you have two possibilities: 
- move directly into them for a weak basic attack
- use one of your skills


You have up to five skill slots, identified by the keys `1` to `5`. To use a skill, press the corresponding key as indicated in the UI. Depending on what the skill does, you have to select a valid target next. Skills that target specific enemies mark each enemy in range with a number. Press that number key to execute the skill effect. To cancel the target selection, press `Escape`.
If the skill targets the player itself, it will execute immediately after pressing the skill key.

You start the game with two weak skills. Dead enemies leave loot behind. Pick it up by walking over it to find new skills. You can equip different skills by pressing `l` and selecting/deselecting from the list of skills you have found so far.

### Development

See `TODO.md` for a roadmap of planned features. `SKILLS.md` holds a short overview of all available skills in the game (hopefully up-to-date, I'm terrible at documentation). When in doubt, look at the skill description in-game.