# class Skill
# -----------
# template to inherit for a generic skill

class Skill
  attr_reader :name, :cost, :description

  def initialize(name: name, cost: cost, description: description)
    @name = name
    @cost = cost
    @description = description
  end
end