require_relative 'skill'

class DisciplinedStrike < Skill
  def initialize
    super(
      name: 'Disciplined Strike',
      cost: 1,
      range: 1,
      target: :both,
      floors: (1..10),
      description: 'deals 1 damage and provides 1 block'
    )
  end

  def effect(enemy, player)
    enemy.take_dmg(1)
    player.block += 1
    "#{enemy.name} gets hit for 1 damage. You gain 1 block."
  end
end