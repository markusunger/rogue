# class Effect
# ------------
# defines different types of effects that can be active on a unit
class Effect
  attr_reader :rounds_remaining
  def initialize(
    name: 'generic effect',
    rounds_remaining: 0,
    description: 'does absolutely nothing'
  )
    @name = name
    @rounds_remaining = rounds_remaining
    @description = description
  end

  def process_turn(unit)
    effect(unit)
    @rounds_remaining -= 1
  end

  def effect(unit)
    nil
  end
end

# Stun Effect
class Stun < Effect
  def initialize
    super(
      name: 'Stun',
      rounds_remaining: 2,
      description: 'Unit cannot do any action.'
    )
  end

  def effect(unit)
    nil
  end
end

# Poison Effect
class Poison < Effect
  def initialize
    super(
      name: 'Poison',
      rounds_remaining: 3,
      description: 'Unit takes damage over time.'
    )
  end

  def effect(unit)
    unit.take_dmg(1)
  end
end

