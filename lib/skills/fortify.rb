require_relative 'skill'

class Fortify < Skill
  def initialize
    super(
      name: 'Fortify',
      cost: 3,
      range: 0,
      target: :self,
      description: 'provides 8 block'
    )
  end

  def effect(player)
    player.block += 8
    "You gain 8 block."
  end
end