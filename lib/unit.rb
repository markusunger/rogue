# class Unit
# ----------
# superclass for both enemies and the player, manages general
# commands identical to both unit types, e.g. the act of moving,
# dealing and receiving damage, ...

class Unit
  attr_accessor :position
  attr_reader :symbol, :name, :style, :hp, :ap, :max_hp

  MAX_HP = 10

  def initialize(symbol: ' ', name: 'generic unit', style: '', hp: MAX_HP, ap: 1)
    @symbol = symbol
    @name = name
    @style = style
    @position = [0,0]
    @hp = hp
    @max_hp = MAX_HP
    @ap = ap
    @effects = []
  end

  def move(new_position, map)
    self.position = new_position if map.walkable?(new_position)
  end

  def process_turn
    @effects.each do |effect|
      effect.process_turn(self)
      if effect.rounds_remaining == 0
        @effects.delete(effect)
      end
    end
  end

  def deal_dmg
    @ap
  end

  def take_dmg(dmg)
    @hp -= dmg
  end

  def dead?
    @hp <= 0
  end

  def apply_effect(effect)
    @effects << effect
  end

  def is_stunned?
    @effects.any? { |e| e.is_a?(Stun) }
  end
end