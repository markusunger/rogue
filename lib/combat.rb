# class Combat
# ------------
# handles everything that happens between an enemy and the player
# when they attack each other, simulates one single combat round

class Combat
  def self.attack(attacker, defender, map, enemies)
    defender.take_dmg(attacker.deal_dmg)
    if defender.dead?
      del = enemies.find_index { |e| e.position == defender.position }
      kill_site = enemies[del].position
      enemies.delete_at(del)
      map.add_entity(kill_site, :remains) # add splatter effect for dead enemies
    end

    {msg: "#{attacker.deal_dmg} damage dealt.", kill: defender.dead?}
  end
end
