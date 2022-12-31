#noinspection RubyNilAnalysis
class LevelUserInputSystem < Draco::System

  def tick(args)
    # this is likely a 'too big' scope class

    if args.inputs.mouse.click
      mouse = args.inputs.mouse
      # heroes
      @world.entities[HealTarget].each do |e|
        if mouse.inside_rect? e.rect
          unless e.health.dead?
            spell_healing_touch(args, e)
            break # stop doing things: we only click once
          end
        end
      end

      # change selected button
      # @world.entities[Button].each do |e|
      #   if e.button.enabled && args.inputs.mouse.inside_rect?(e.rect)
      #
      #     # deselect all buttons
      #     @world.entities[Button].each do |e|
      #       e.button.selected = false
      #     end
      #
      #     # select this button
      #     e.button.selected = true
      #
      #     break # stop doing things
      #   end
      # end
    end

    if args.inputs.keyboard.key_up.one # healing touch
      @world.entities[HealTarget].each do |e|
        if args.inputs.mouse.inside_rect? e.rect
          unless e.health.dead?
            spell_healing_touch(args, e)
            break # stop doing things: we only click once
          end
        end
      end
    elsif args.inputs.keyboard.key_up.two && @world.spell2.button.enabled && @world.spell2.button.cooldown <= 0 # smite
      @world.spell2.button.cooldown = 5.seconds
      @world.entities[Enemy].each do |e|
        next if e.health.dead?
        spell_smite(args, e)
        break
      end
    elsif args.inputs.keyboard.key_up.three && @world.spell3.button.enabled && @world.spell3.button.cooldown <= 0 # stun
      @world.spell3.button.cooldown = @world.level.stun_power.value.seconds
      @world.entities[EnemyAi].each do |e|
        next if e.health.dead?
        spell_stun(args, e)
      end
      args.sfx.play(:spell_stun_1)
    elsif args.inputs.keyboard.key_up.four && @world.spell4.button.enabled && @world.spell4.button.cooldown <= 0 # cure
      @world.spell4.button.cooldown = @world.level.cure_power.value.seconds
      @world.entities[HealTarget].each do |e|
        next if e.health.dead?
        spell_cure(args, e)
        break
      end
      args.sfx.play(:spell_stun_1)
    else
    end

    # this may not be the right place for this logic
    @world.spell2.button.cooldown -= 1 if @world.spell2.button.cooldown > 0
    @world.spell3.button.cooldown -= 1 if @world.spell3.button.cooldown > 0
    @world.spell4.button.cooldown -= 1 if @world.spell4.button.cooldown > 0
  end

  def spell_smite(args, e)
    # damage specified target
    e.take_damage(args, @world.level.smite_power.value)
    #e.health.value = e.health.max_value
    # spell effect?
    # TBD
    # sound effect
    args.sfx.play(:spell_smite_1)

    @world.entities << TextEntity.new({
      position: {x: e.position.x + e.sprite.w.half - 24, y: e.position.y + e.sprite.h.half + 40 },
      acceleration: { y: -0.1 },
      velocity: { x: 6.5, y: 1 + rand(3) },
      text: { value: "-#{@world.level.smite_power.value}", delete_at: args.tick_count + 100, r: 255, g: 255, b: 0 }
    })
  end

  def spell_cure(args, e)
    # heal things
    e.health.value = e.health.max_value
    # spell effect?
    # TBD
    # sound effect
    args.sfx.play(:spell_heal_1)
  end

  def spell_healing_touch(args, e)
    # heal things
    heal_power = @world.level.heal_power.value
    e.health.add(heal_power)

    # bring dead things back to life
    if e.sprite.state == :defeat_1
      e.sprite.state = :idle_1
    end

    # spell
    size_modifier = ((@world.level.heal_power.upgrade_tier + 1) * 0.2) + 0.5
    w = e.sprite.w * size_modifier
    h = e.sprite.h * size_modifier

    spawn_x = e.position.x - w.half + rand(e.sprite.w)
    spawn_y = e.position.y - h.half + rand(e.sprite.h)

    @world.entities << SpellEffectEntity.new(
      position: { x: spawn_x, y: spawn_y },
      sprite: { w: w, h: h }
    )

    args.sfx.play(:spell_heal_1)
  end

  def spell_stun(args, e)
    log "STUN!"
    e.enemy_ai.state = :ai_stunned
    e.enemy_ai.state_change_at = args.tick_count
    e.sprite.shake_until = args.tick_count + 1.seconds.half
    e.sprite.flash_at = args.tick_count
    e.sprite.flash_duration = 1.seconds.half
  end
end