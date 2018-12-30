# module RoundActions
# ------------------
# methods for actions that can occur on an individual level and
# be triggered either by the action controller or other level methods

module RoundActions
  def render_map(&block)
    # determines what entity, unit or tile to actually output in the frontend,
    # considering both background an foreground styles
    enum = @map.draw
    enum.each do |tile, position|
      to_draw = nil
      possible_unit = @enemies.find { |a| a.position == position }
      possible_unit = @player if position == @player.position

      to_draw = [{
        symbol: possible_unit&.symbol || tile[:symbol],
        style: possible_unit&.style || tile[:style],
        bgstyle: tile[:bgstyle]
      }, position]

      yield(to_draw) if block_given?
    end
  end

  def init_player_position
    # randomly set player starting position to a free tile
    starting_position = @map.farthest_from_exit
    @player.move(starting_position, @map)
  end

  def add_enemies(no)
    no.times do 
      new_enemy = Enemy.new
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
      result[:kill] ? (result[:msg] + ' It\'s a kill!') : result[:msg]
    elsif @map.adjacent?(@player.position, new_position)
      @player.move(new_position, @map)
      ''
    else
      'Cannot move, destination blocked?'
    end
  end
  
  def act_enemy(position)
    enemy = @enemies.find { |e| e.position == position }
    return '' unless enemy # check if enemy died during the round 
    decision = @map.adjacent?(enemy.position, @player.position) ? :attack : :move

    if decision == :move
      pick = @map.closer_to_player(enemy.position, @player.position)
      enemy.move(pick, @map) unless anyone_there?(pick)
      ''
    elsif decision == :attack
      "Enemy attacks the player!"
    end
  end

  def use_skill(slot)
    @player.use_skill(slot.to_i)
  end

  def check_for_win_state
    @win_state = @player.position == @map.exit_position ? true : false
    ''
  end
end