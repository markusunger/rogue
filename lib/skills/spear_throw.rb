require_relative 'skill'

class SpearThrow < Skill
  def initialize
    super(
      name: 'Spear Throw',
      cost: 3,
      range: 3,
      target: :enemy,
      description: '5 damage up to a range of 3'
    )
  end

  def effect(enemy)
    enemy.take_dmg(5)
    "Enemy hit for 5 damage."
  end
end
