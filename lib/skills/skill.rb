# class Skill
# -----------
# template to inherit for a generic skill

class Skill
  attr_reader :name, :cost, :range, :target, :description

  def initialize(name: name, cost: cost, range: range, target: target, description: description)
    @name   = name
    @cost   = cost
    @range  = range
    @target = target
    @description = description
  end

  def effect
    nil
  end
end