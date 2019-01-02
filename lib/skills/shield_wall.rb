require_relative 'skill'

class ShieldWall < Skill
  def initialize
    super(
      name: 'Shield Wall',
      cost: 4,
      range: 0,
      target: :self,
      floors: (1..10),
      description: '+2 block each turn'
    )
  end

  def effect(player)
    player.block_per_turn += 2
    "You gain 2 block per turn."
  end
end