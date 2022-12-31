#noinspection RubyNilAnalysis
class LevelHeroAiSystem < Draco::System
  #filter(EnemyAi)

  def tick(args)
    return if @world.level.level_progress.state != :in_progress

    @world.entities[HeroAi].each do |e|
      if e.hero_ai.state_change_at <= args.tick_count
        case e.hero_ai.state
        when :ai_dead
          # stay dead
        when :unknown, :ai_attack, :ai_hurt
          # change to wait
          wait(args, e)
        when :ai_wait
          # change to attack
          attack(args, e)
        else
          log "[HERO AI] Unknown state change!!!"
          # type code here
        end
      end
    end
  end

  def wait(args, e)
    e.hero_ai.state = :ai_wait
    e.hero_ai.state_change_at = args.tick_count + 72 + rand(100)

    e.sprite.frame = 0
    e.sprite.state = :idle_1
    #log "[HERO AI] Change to wait."
  end

  def attack(args, e)
    e.hero_ai.state = :ai_attack
    e.hero_ai.state_change_at = args.tick_count + 24

    e.sprite.frame = 0
    e.sprite.state = :attack_1
    #log "[HERO AI] Change to attack."

    target = pick_target
    unless target.nil?
      args.sfx.play(:sword_attack_1)
      target.take_damage(args, e.attack_power.value)

      @world.entities << TextEntity.new({
        position: {x: target.position.x + target.sprite.w.half - 24, y: target.position.y + target.sprite.h.half + 40 },
        acceleration: { y: -0.1 },
        velocity: { x: 6, y: 1 + rand(3) },
        text: { value: "-#{e.attack_power.value.trim}", delete_at: args.tick_count + 100, r: 255, g: 0, b: 0 }
      })
    end
  end

  def pick_target
    target = nil

    @world.entities[Enemy,Health].each do |e|
      unless e.health.dead?
        target = e
        break
      end
    end

    target
  end
end