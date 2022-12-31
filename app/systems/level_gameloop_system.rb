#noinspection RubyNilAnalysis
class LevelGameloopSystem < Draco::System

  def tick(args)
    # this system's job is to monitor end conditions using the level progress entity
    #
    return unless @world.level.level_progress.state == :in_progress

    # Monitor heroes health (monitor loss condition)
    #
    hero_health = @world.barbarian.health.value
    args.state.hero_health = hero_health
    if hero_health == 0
      log "[LEVEL] All heroes have died."
      @world.level.level_progress.state = :complete
      @world.transition_to_death(args)
    end

    # Monitor enemies health (monitor win condition)
    #
    enemy_health = 0
    @world.entities[Enemy].each do |e|
      enemy_health += e.health.value
    end

    if enemy_health == 0 && @world.level.level_progress.events.length < 1
      # player win condition (TBD: make more complex)
      log "[LEVEL] All enemies have died."
      @world.level.level_progress.state = :complete
      @world.transition_to_win(args)
    end

    # Monitor events (spawn enemies out of the event queue)
    #
    if @world.level.level_progress.events.length > 0
      e = @world.level.level_progress.events[0]
      event_time = args.tick_count - @world.level.level_progress.started_at
      if e.at <= event_time
        process_event(args, e)
        @world.level.level_progress.events.delete_at(0)
      end
    end
  end

  def process_event(args, e)
    case e.event_id
    when :spawn_skeleton

      e.scale = 1.0 if e.scale.nil?
      e.r = 255 if e.r.nil?
      e.g = 255 if e.g.nil?
      e.b = 255 if e.b.nil?

      size = 192 * 1.25
      size *= e.scale

      spawn_x = 640 + rand(args.grid.w - 640 - size)
      spawn_y = 128
      spawn_y -= ((18 * e.scale) - 18)

      # add entity
      @world.entities << EnemyEntity.new(
        position: { x: spawn_x, y: spawn_y },
        sprite: { type: :skeleton, state: :idle_1, w: size, h: size, scale: e.scale, r: e.r, g: e.g, b: e.b },
        health: { value: e.health, max_value: e.health },
        attack_power: { value: e.attack_power }
      )

      # play sfx
      args.sfx.play(:combat_spawn_1)

      # add ground/dust effect
      @world.entities << SpellEffectEntity.new(
        position: { x: spawn_x, y: spawn_y + 16 },
        sprite: { type: :air_impact_1, w: size, h: size / 3 }
      )
    else
      # type code here
    end
  end
end