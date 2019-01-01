require_relative 'skill'

class Pierce < Skill
  def initialize
    super(
      name: 'Pierce',
      cost: 2,
      range: 1,
      target: :enemy,
      description: 'deal 2 damage in melee range'
    )
  end

  def effect(enemy)
    enemy.take_dmg(2)
    "#{enemy.name} gets pierced for 2 damage."
  end
end
