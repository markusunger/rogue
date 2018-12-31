class ActionController
  attr_reader :queue

  def initialize
    @queue = []
  end

  def enqueue(command, param = nil)
    @queue << {command: command, param: param}
  end

  def execute(level)
    messages = []

    until @queue.empty? do
      action = @queue.shift

      case action[:command]
      when 'reset'
        messages << level.reset
      when 'act_player'
        messages << level.act_player(action[:param])
      when 'act_enemy'
        messages << level.act_enemy(action[:param])
      when 'handle_skill'
        messages << level.handle_skill(action[:param])
      when 'reset_active_skill'
        messages << level.reset_active_skill
      when 'check_for_win_state'
        messages << level.check_for_win_state
      when 'check_for_loss_state'
        messages << level.check_for_loss_state
      when 'win'
        messages << "You climb deeper down ..."
      end
    end

    messages
  end
end
