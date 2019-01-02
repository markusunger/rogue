require_relative 'skill'

class TastySnack < Skill
  def initialize
    super(
      name: 'Tasty Snack',
      cost: 0,
      range: 0,
      target: :self,
      floors: (1..5),
      description: 'provides 3 energy'
    )
  end

  def effect(player)
    player.energy += 3
    "You gain 3 energy."
  end
end