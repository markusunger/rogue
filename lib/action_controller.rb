class ActionController
  attr_reader :queue

  def initialize
    @queue = []
  end

  def enqueue(command, param = nil)
    @queue << {command: command, param: param}
  end

  def execute(level)
    @level = level
    messages = []

    until @queue.empty? do
      action = @queue.shift

      case action[:command]
      when 'reset'
        messages << @level.reset
      when 'act_player'
        messages << @level.act_player(action[:param])
      when 'act_enemy'
        messages << @level.act_enemy(action[:param])
      when 'use_skill'
        messages << @level.use_skill(action[:param])
      when 'check_for_win_state'
        messages << @level.check_for_win_state
      when 'win'
        messages << "You climb deeper down ..."
      end
    end

    messages
  end
end
