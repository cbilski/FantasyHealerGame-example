class EnemyEntity < Draco::Entity
  component Tag(:enemy) # ==> "component Enemy"
  component EnemyAi
  component Position, x: 960, y: 128
  component Sprite, type: :skeleton, state: :idle_1, w: 320, h: 320
  component Health, value: 4, max_value: 4
  component AttackPower, value: 1.0
  component Portrait, tile_x: 90, tile_y: 16, tile_w: 76, tile_h: 76, path: '/sprites/enemies/Toomask-gdm/SKELETON/PORTRAIT/skeletonPORTRAITleft.png'

  def initialize(args = {})
    super
  end

  def take_damage(args, amount)
    h = health.value
    return if h <= 0

    args.sfx.play(:weapon_impact_1) # get hurt SFX from target

    h -= amount
    h = 0 if h < 0

    health.value = h
    sprite.shake_until = args.tick_count + 20

    if h > 0
      # hero_ai.state = :ai_hurt
      # hero_ai.state_change_at = args.tick_count + 30
      #
      # sprite.state = :hurt_1
      # sprite.frame = 0
    else
      enemy_ai.state = :ai_dying
      enemy_ai.state_change_at = args.tick_count + 90

      sprite.state = :defeat_1
      sprite.frame = 0
      sprite.fade_at = args.tick_count

      args.sfx.play(:enemy_death_1)
    end
  end
end