require_relative 'unit'
require_relative 'skills/skill'

Dir[File.dirname(__FILE__) + '/skills/*.rb'].each do |s|
  require_relative 'skills/' + File.basename(s, '.rb')
end

# class Player
# ------------
# methods and stats unique to just the player unit

class Player < Unit
  attr_accessor :energy, :energy_per_turn, :block, :block_per_turn, :active_skill
  attr_reader   :skills

  STARTING_ENERGY = 5 # energy points at the start of each level
  ENERGY_PER_TURN = 1 # energy points to gain at the start of each round

  def initialize
    super(symbol: '@', name: 'Player', style: 'player')
    @ap = 1 # basic AP for the player when not using skills
    refresh

    @skills = [ShieldWall.new, AimedArrow.new, ShieldBash.new, Pierce.new, Fortify.new]
    @active_skill = nil
  end

  def process_turn
    super
    @energy += @energy_per_turn
    @block += @block_per_turn
  end

  def refresh
    @energy = STARTING_ENERGY
    @energy_per_turn = ENERGY_PER_TURN
    @block = 0
    @block_per_turn = 0
  end

  def use_skill_on_self
    skill = @active_skill
    return 'No skill selected!' unless skill
    if skill.cost > @energy
      "Not enough energy to use #{skill.name}."
    else
      @energy -= skill.cost
      skill.effect(self)
    end
  end

  def take_dmg(dmg)
    @block -= dmg
    if @block < 0
      @hp += @block
      @block = 0
    end
  end
end