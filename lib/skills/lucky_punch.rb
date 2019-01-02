require_relative 'skill'

class LuckyPunch < Skill
  def initialize
    super(
      name: 'Lucky Punch',
      cost: 2,
      range: 1,
      target: :enemy,
      floors: (1..7),
      description: 'deal between 1 and 4 damage'
    )
  end

  def effect(enemy)
    dmg_roll = (1..4).to_a.sample
    enemy.take_dmg(dmg_roll)
    "#{enemy.name} gets punched for #{dmg_roll} damage."
  end
end
