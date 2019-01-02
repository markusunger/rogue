require_relative 'skill'

class AimedArrow < Skill
  def initialize
    super(
      name: 'Aimed Arrow',
      cost: 5,
      range: 4,
      target: :enemy,
      floors: (7..10),
      description: '9 damage up to a range of 4'
    )
  end

  def effect(enemy)
    enemy.take_dmg(9)
    "#{enemy.name} gets shot for 9 damage."
  end
end