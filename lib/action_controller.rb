# class ActionController
# ----------------------
# implements a simple FIFO stack to process actions in the correct order

class ActionController
  attr_reader :queue

  def initialize
    @queue = []
  end

  def enqueue(command, param = nil)
    @queue << {command: command, param: param}
  end

  def execute(engine)
    messages = []
    map      = engine.level.map
    player   = engine.level.player
    enemies  = engine.level.enemies

    until @queue.empty? do
      action = @queue.shift
      
      messages << case action[:command]
      when 'reset'
        engine.reset
      when 'act_player'
        engine.act_player(map, player, enemies, action[:param])
      when 'act_enemy'
        engine.act_enemy(map, player, enemies, action[:param])
      when 'handle_skill'
        engine.handle_skill(map, player, enemies, action[:param])
      when 'reset_active_skill'
        engine.reset_active_skill(player)
      when 'add_skill'
        engine.add_skill(player, action[:param])
      when 'remove_skill'
        engine.remove_skill(player, action[:param])
      end
    end

    messages
  end
end
