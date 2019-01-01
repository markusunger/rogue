require_relative 'skill'

class AimedArrow < Skill
  def initialize
    super(
      name: 'Aimed Arrow',
      cost: 5,
      range: 4,
      target: :enemy,
      description: '9 damage up to a range of 5'
    )
  end

  def effect(enemy)
    enemy.take_dmg(9)
    "#{enemy.name} gets shot for 9 damage."
  end
end