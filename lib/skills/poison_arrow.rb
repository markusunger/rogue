require_relative 'skill'
require_relative '../effects'

class PoisonArrow < Skill
  def initialize
    super(
      name: 'Poison Arrow',
      cost: 3,
      range: 4,
      target: :enemy,
      floors: (1..10),
      description: 'poisons enemy for 3 rounds up to a range of 4'
    )
  end

  def effect(enemy)
    enemy.apply_effect(Poison.new(3, 1))
    "#{enemy.name} is now poisoned."
  end
end