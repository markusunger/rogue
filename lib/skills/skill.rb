# class Skill
# -----------
# template to inherit for a generic skill

class Skill
  attr_reader :name, :cost, :range, :target, :floors, :description

  def initialize(
      name: 'generic skill',
      cost: 0,
      range: 0,
      target: :self,
      floors: (1..10),
      description: 'does absolutely nothing'
    )
    @name   = name
    @cost   = cost
    @range  = range
    @target = target
    @floors = floors
    @description = description
  end

  def effect
    nil
  end
end