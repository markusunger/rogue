require_relative 'skill'

class Pierce < Skill
  def initialize
    super(
      name: 'Pierce',
      cost: 2,
      range: 1,
      target: :enemy,
      floors: (1..10),
      description: 'deal 2 damage'
    )
  end

  def effect(enemy)
    enemy.take_dmg(2)
    "#{enemy.name} gets pierced for 2 damage."
  end
end
