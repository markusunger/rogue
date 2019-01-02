require_relative 'skill'

class AxeThrow < Skill
  def initialize
    super(
      name: 'Axe Throw',
      cost: 3,
      range: 3,
      target: :enemy,
      floors: (1..6),
      description: '4 damage up to a range of 3'
    )
  end

  def effect(enemy)
    enemy.take_dmg(4)
    "#{enemy.name} gets slashed for 4 damage."
  end
end
