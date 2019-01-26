# module GameActions
# ------------------
# methods for actions that can occur on an individual level and
# be triggered either by the action controller or other GameEngine methods

# this is quite a heavy file and the code looks messy, but it keeps
# all the game logic that can occur on a turn-by-turn basis in one
# place

module GameActions
  def anyone_there?(player, enemies, position)
    # checks if a player or an enemy is at the target position
    to_check = [*enemies.map(&:position)] + [player.position] 
    to_check.any? { |e| e == position }
  end
  
  def act_player(map, player, enemies, new_position)
    # handles the '/act/x,y' route and determines the result of player movement
    new_position = [ # convert from the URL parameter format
      *new_position
        .split(',')
        .map(&:to_i)
    ] 
    to_attack = enemies.find do |e|
      e.position == new_position
    end

    if to_attack
      result = Combat::attack(player, to_attack, map, enemies) 
      if result[:kill]
        result[:msg] + " It's a kill!"
      else
        result[:msg]
      end
    elsif map.adjacent?(player.position, new_position)
      player.move(new_position, map)
      lootable_skills = map.lootable_skills(new_position)

      if lootable_skills
        msg = []
        lootable_skills.times do
          msg << player.add_random_skill(@floor_number)
        end
        map.remove_specific_entities(:loot, new_position)
        reset_active_skill(player)
        return msg.shift
      end
      reset_active_skill(player)
      ''
    else
      'Cannot move, destination blocked?'
    end
  end
  
  def act_enemy(map, player ,enemies, position)
    # determines what a specific enemy does on his turn
    message = ''
    enemy = enemies.find do |e|
      e.position == position
    end

    return message unless enemy # check if enemy died during the round

    decision = map.adjacent?(enemy.position, player.position) ? :attack : :move

    if enemy.is_stunned?
      # no actions for stunned enemies
      enemy.process_turn(enemies, map, @log)
      return message
    end

    if decision == :move
      choices = map.closer_to_player(enemy.position, player.position)
      choice = choices.find do |c|
        !anyone_there?(player, enemies, c)
      end
      enemy.move(choice, map)
    elsif decision == :attack
      result = Combat::attack(enemy, player, map, enemies)
      message << result[:msg]
    end
    enemy.process_turn(enemies, map, @log)
    message
  end

  def handle_skill(map, player, enemies, slot)
    # handles skill keypress and determines whether targeting is necessary
    # or if the skill is cast on the player itself
    if player.active_skill
      execute_skill(map, player, enemies, slot)
    else
      skill_index = slot.to_i - 1
      skill = player.skillset[skill_index]

      if skill.cost > player.energy
        return "Not enough energy to use #{skill.name}."
      end

      player.active_skill = skill

      if skill.target == :self
        return execute_skill(map, player, enemies, nil) 
      end

      target_tiles = map.active_tiles_in_range(player.position, skill.range)
      target_tiles.each do |target|
        map.add_entity(target, :marker)
      end
      ''
    end
  end

  def execute_skill(map, player, enemies, slot)
    # determines the actual results of the skill execution
    msg = nil
    skill = player.active_skill

    if skill.target == :enemy || skill.target == :both
      enemy = enemies[slot.to_i - 1]
      unless enemy
        reset_active_skill(player)
        return 'No valid enemy selected.'
      end
      unless map.in_range?(skill.range, player.position, enemy.position)
        reset_active_skill(player)
        return 'Not in range of that enemy.'
      end
      result = Combat::skill(skill, player, enemy, map, enemies)
      msg = result[:msg]
    end

    msg = player.use_skill_on_self if skill.target == :self
    player.active_skill = nil
    process_turn
    msg
  end

  def reset_active_skill(player)
    player.active_skill = nil
    ''
  end

  def add_skill(player, skill_name)
    # reconstruct class object from its name as a string and instantiate
    player.skillset << Object.const_get(skill_name).new
    ''
  end

  def remove_skill(player, skill_name)
    # reconstruct class object from its name as a string and delete from player skillset
    skill = Object.const_get(skill_name)
    player.skillset.delete_if do |s|
      s.is_a?(skill)
    end
    ''
  end

  def reset_markers(map)
    # if targetting is finished or aborted, removes all target markers
    map.remove_all_entities(:marker)
  end

  def level_won?
    # check winning conditions
    on_exit      = @level.player.position == @level.map.exit_position
    enemies_dead = @level.enemies.empty?

    on_exit && enemies_dead
  end

  def game_lost?
    @level.player.dead?
  end

  def game_lost_actions
    # reset level and floor number, populate last_round object for the stats screen
    @floor_number = 1
    @last_round = draw
    @level = Level.new(@floor_number)
    @has_lost = true
  end

  def level_won_actions
    # handles either a floor or a game win
    @floor_number += 1
    if @floor_number > self.class::FLOORS_TO_WIN
      @game_won = true
      @floor_number = 1
      @last_round = draw
      @level = Level.new(@floor_number)
      @has_won = true
    else
      @level.next(@floor_number)
      @log << 'You climb deeper down.'
    end
  end
end