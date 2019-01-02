require_relative 'skill'

class DefensiveStance < Skill
  def initialize
    super(
      name: 'Defensive Stance',
      cost: 2,
      range: 0,
      target: :self,
      floors: (1..10),
      description: 'provides 3 block'
    )
  end

  def effect(player)
    player.block += 3
    "You gain 3 block."
  end
end