require_relative 'skill'

class Rejuvenation < Skill
  def initialize
    super(
      name: 'Rejuvenation',
      cost: 2,
      range: 0,
      target: :self,
      floors: (6..10),
      description: 'provides 4 energy and heals 1 hp'
    )
  end

  def effect(player)
    player.energy += 4
    player.heal(1)
    "You gain 4 energy and 1 hp."
  end
end