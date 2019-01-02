require_relative 'unit'

class Enemy < Unit
  attr_reader :spawns_on_floor

  def self.spawns_on_floor
    self.new.spawns_on_floor
  end
end

class Goblin < Enemy
  def initialize
    super(
      symbol: 'µ',
      name: 'Goblin',
      style: 'enemy',
      hp: (2..3).to_a.sample,
      ap: 1
    )
    @spawns_on_floor = (1..5)
  end
end

class GiantSpider < Enemy
  def initialize
    super(
      symbol: '¥',
      name: 'Giant Spider',
      style: 'enemy',
      hp: (3..6).to_a.sample,
      ap: 1
    )
    @spawns_on_floor = (4..8)
  end
end

class Orc < Enemy
  def initialize
    super(
      symbol: 'O',
      name: 'Orc',
      style: 'enemy',
      hp: (6..8).to_a.sample,
      ap: 2
    )
    @spawns_on_floor = (5..10)
  end
end