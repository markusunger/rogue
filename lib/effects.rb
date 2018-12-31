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

