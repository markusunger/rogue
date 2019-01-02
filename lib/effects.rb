# class Effect
# ------------
# defines different types of effects that can be active on a unit
class Effect
  attr_reader :rounds_remaining, :adjective
  def initialize(
    name: 'generic effect',
    rounds_remaining: 0,
    description: 'does absolutely nothing',
    adjective: 'effected'
  )
    @name = name
    @rounds_remaining = rounds_remaining
    @description = description
    @adjective = adjective
  end

  def process_turn(unit, enemies, map)
    effect(unit)
    @rounds_remaining -= 1
    Combat::handle_dead_enemy(unit, enemies, map) if unit.dead?
  end

  def effect(unit)
    nil
  end
end

# Stun Effect
class Stun < Effect
  def initialize(rounds)
    super(
      name: 'Stun',
      rounds_remaining: rounds,
      description: 'Unit cannot do any action.',
      adjective: 'stunned'
    )
  end

  def effect(unit)
    nil
  end
end

# Poison Effect
class Poison < Effect
  def initialize(rounds, dmg)
    @dmg = dmg
    super(
      name: 'Poison',
      rounds_remaining: rounds,
      description: 'Unit takes damage over time.',
      adjective: 'poisoned'
    )
  end

  def effect(unit)
    unit.take_dmg(@dmg)
  end
end