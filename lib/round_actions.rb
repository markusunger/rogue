# module RoundActions
# ------------------
# methods for actions that can occur on an individual level and
# be triggered either by the action controller or other level methods

# this is quite a heavy file, but it kinda makes sense to have everything
# in one place, so I'm not going to split it up :P

module RoundActions
  def render_map(&block)
    # determines what entity, unit or tile to actually output in the frontend,
    # considering both background an foreground styles
    enum = @map.draw
    enum.each do |tile, position|
      to_draw = nil
      info = []
      possible_unit = @enemies.find { |a| a.position == position }
      if possible_unit
        info << "Enemy: #{possible_unit.name} (#{possible_unit.hp}/#{possible_unit.max_hp})" 
      end 
      possible_unit = @player if position == @player.position
      info << "You are here!" if position == @player.position 
      info << "Tile: #{tile[:name].capitalize}"

      to_draw = [{
        symbol: possible_unit&.symbol || tile[:symbol],
        style: possible_unit&.style || tile[:style],
        bgstyle: tile[:bgstyle]
      }, position, info]

      yield(to_draw) if block_given?
    end
  end

  def init_player_position
    # randomly set player starting position to a free tile
    starting_position = @map.farthest_from_exit
    @player.move(starting_position, @map)
  end

  def add_enemies(no)
    # Create a list of Enemy classes that are suited for this floor
    enemies_for_floor = [Goblin, Orc, GiantSpider]
    .select { |e| e.spawns_on_floor.cover?(@floor_number) }

    no.times do
      new_enemy = enemies_for_floor.sample.new
      spawn = nil
      loop do
        spawn = @map.find_enemy_spawn(@player.position)
        break unless @enemies.find { |e| e.position == spawn }
      end
      new_enemy.move(spawn, @map)
      @enemies << new_enemy
    end
  end

  def anyone_there?(position)
    to_check = [*@enemies.map(&:position)] + [@player.position] 
    to_check.any? { |e| e == position }
  end
  
  def act_player(new_position)
    new_position = [*new_position.split(',').map(&:to_i)] # convert from the URL parameter format
    to_attack = @enemies.find { |e| e.position == new_position }

    if to_attack
      result = Combat::attack(@player, to_attack, @map, @enemies) 
      if result[:kill]
        result[:msg] + " It's a kill!"
      else
        result[:msg]
      end
    elsif @map.adjacent?(@player.position, new_position)
      @player.move(new_position, @map)
      lootable_skills = @map.lootable_skills(new_position)
      if lootable_skills
        msg = []
        lootable_skills.times { msg << @player.add_random_skill(@floor_number) }
        @map.remove_specific_entities(:loot, new_position)
        reset_active_skill
        return msg.shift
      end
      reset_active_skill
      ''
    else
      'Cannot move, destination blocked?'
    end
  end
  
  def act_enemy(position)
    message = ''
    enemy = @enemies.find { |e| e.position == position }
    return message unless enemy # check if enemy died during the round
    decision = @map.adjacent?(enemy.position, @player.position) ? :attack : :move
    if enemy.is_stunned?
      enemy.process_turn
      return message
    end

    if decision == :move
      choices = @map.closer_to_player(enemy.position, @player.position)
      choice = choices.find { |c| !anyone_there?(c) }
      enemy.move(choice, @map)
    elsif decision == :attack
      result = Combat::attack(enemy, @player, @map, @enemies)
      @loss_state = false if result[:kill]
      message << result[:msg]
    end
    enemy.process_turn
    message
  end

  def handle_skill(slot)
    if @player.active_skill
      execute_skill(slot)
    else
      skill_index = slot.to_i - 1
      skill = @player.skillset[skill_index]
      return "Not enough energy to use #{skill.name}." if skill.cost > @player.energy
      @player.active_skill = skill
      return execute_skill(nil) if skill.target == :self
      target_tiles = @map.active_tiles_in_range(@player.position, skill.range)
      target_tiles.each do |target|
        @map.add_entity(target, :marker)
      end
      ''
    end
  end

  def execute_skill(slot)
    msg = nil
    skill = @player.active_skill
    case skill.target
      when :enemy
        enemy = @enemies[slot.to_i - 1]
        unless enemy
          reset_active_skill
          return 'No valid enemy selected.'
        end
        unless @map.in_range?(skill.range, @player.position, enemy.position)
          reset_active_skill
          return 'Not in range of that enemy.'
        end
        result = Combat::skill(skill, @player, enemy, @map, @enemies)
        msg = result[:msg]
      when :self  then msg = @player.use_skill_on_self
    end
    @player.active_skill = nil
    process_turn
    msg
  end

  def reset_active_skill
    @player.active_skill = nil
    ''
  end

  def add_skill(name)
    # reconstruct class object from its name as a string and instantiate
    @player.skillset << Object.const_get(name).new
    ''
  end

  def remove_skill(name)
    puts "Removing skill #{name}..."
    skill = Object.const_get(name)
    @player.skillset.delete_if { |s| s.is_a?(skill) }
    ''
  end

  def reset_markers
    @map.remove_all_entities(:marker)
  end

  def check_for_win_state
    on_exit = @player.position == @map.exit_position
    enemies_dead = @enemies.empty?
    @win_state = on_exit && enemies_dead
    ''
  end

  def check_for_loss_state
    @loss_state = @player.dead?
    ''
  end
end