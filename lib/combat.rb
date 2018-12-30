# class Combat
# ------------
# handles everything that happens between an enemy and the player
# when they attack each other, simulates one single combat round

class Combat
  def self.attack(attacker, defender, map, enemies)
    defender.take_dmg(attacker.deal_dmg)
    handle_dead_enemy(defender, enemies, map) if defender.dead?

    {msg: "#{attacker.deal_dmg} damage dealt.", kill: defender.dead?}
  end

  def self.skill(skill, attacker, defender, map, enemies)
    attacker.energy -= skill.cost
    skill.effect(defender)
    handle_dead_enemy(defender, enemies, map) if defender.dead?

    {msg: "Damage dealt.", kill: defender.dead?}
  end

  def self.handle_dead_enemy(defender, enemies, map)
    del = enemies.find_index { |e| e.position == defender.position }
    kill_site = enemies[del].position
    enemies.delete_at(del)
    map.add_entity(kill_site, :remains) # add splatter effect for dead enemies
  end
end
