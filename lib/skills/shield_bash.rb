require_relative 'skill'
require_relative '../effects'

class ShieldBash < Skill
  def initialize
    super(
      name: 'Shield Bash',
      cost: 2,
      range: 1,
      target: :enemy,
      floors: (3..10),
      description: 'stun enemy for 2 rounds'
    )
  end

  def effect(enemy)
    enemy.apply_effect(Stun.new(2))
    "#{enemy.name} is now stunned."
  end
end
