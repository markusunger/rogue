require_relative 'unit'

# class Enemy
# -----------
# methods and stats unique to just enemy units

class Enemy < Unit
  def initialize
    super(symbol: 'µ', style: 'enemy', hp: 1)
  end
end