require_relative 'unit'

# Dir.glob('skills/*') { |s| p s }
require_relative 'skills/shield_wall'

# class Player
# ------------
# methods and stats unique to just the player unit

class Player < Unit
  attr_accessor :energy, :energy_per_turn, :block, :block_per_turn
  attr_reader   :skills

  STARTING_ENERGY = 5 # energy points at the start of each level
  ENERGY_PER_TURN = 1 # energy points to gain at the start of each round

  def initialize
    super(symbol: '@', style: 'player')
    @energy = STARTING_ENERGY
    @energy_per_turn = ENERGY_PER_TURN
    @block = 0
    @block_per_turn = 0

    @skills = [ShieldWall.new]
  end

  def process_turn
    @energy += @energy_per_turn
    @block += @block_per_turn
  end

  def use_skill(slot)
    skill = @skills[slot-1]
    if skill.cost > @energy
      "Not enough energy to use #{skill.name}."
    else
      @energy -= skill.cost
      skill.effect(self)
    end
  end
end