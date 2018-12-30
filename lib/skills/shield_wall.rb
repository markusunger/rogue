require_relative 'skill'

class ShieldWall < Skill
  def initialize
    super(
      name: 'Shield Wall',
      cost: 5,
      range: 0,
      target: :self,
      description: '+5 block each turn'
    )
  end

  def effect(player)
    player.block_per_turn += 5
    "You gain 5 block per turn!"
  end
end