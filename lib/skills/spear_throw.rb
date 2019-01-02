require_relative 'skill'

class SpearThrow < Skill
  def initialize
    super(
      name: 'Spear Throw',
      cost: 3,
      range: 3,
      target: :enemy,
      floors: (1..10),
      description: '5 damage up to a range of 3'
    )
  end

  def effect(enemy)
    enemy.take_dmg(5)
    "#{enemy.name} takes a spear for 5 damage."
  end
end
