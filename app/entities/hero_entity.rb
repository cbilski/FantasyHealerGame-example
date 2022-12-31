class HeroEntity < Draco::Entity
  component Tag(:click_target)  # ==> "component ClickTarget"
  component Tag(:heal_target)   # ==> "component HealTarget"
  component Tag(:hero)          # ==> "component Hero"
  #component Tag(:player_avatar) # ==> "component PlayerAvatar"
  component Position, x: 64, y: 128
  component Sprite, type: :healer, state: :idle_1, w: 160, h: 160
  component Portrait, tile_x: 0, tile_y: 0, tile_w: 136, tile_h: 136, path: '/sprites/heroes/azuna-pixels.itch.io/BARBARIAN/PORTRAIT-1.png'
  component HeroAi
  component Health, value: 5, max_value: 5
  component AttackPower, value: 1.0
  component DamageReduction, value: 0.0

  def initialize(args = {})
    super
  end

  def reset
    health.reset
    sprite.state = :idle_1
  end

  def take_damage(args, amount)
    h = health.value
    return if h <= 0

    args.sfx.play(:hurt_male_1) # get hurt SFX from target

    h -= amount
    h = 0 if h < 0

    health.value = h
    if h > 0
      hero_ai.state = :ai_hurt
      hero_ai.state_change_at = args.tick_count + 30

      sprite.state = :hurt_1
      sprite.frame = 0
    else
      hero_ai.state = :ai_dead

      sprite.state = :defeat_1
      sprite.frame = 0
    end
  end
end