#noinspection RubyNilAnalysis
class LevelEnemyAiSystem < Draco::System
  #filter(EnemyAi)

  def tick(args)
    #return unless args.tick_count.zmod?(10)
    return if @world.level.level_progress.state != :in_progress

    @world.entities[EnemyAi].each do |e|

      if e.enemy_ai.state_change_at <= args.tick_count
        case e.enemy_ai.state
        when :unknown, :ai_attack, :ai_stunned
          # change to wait
          wait(args, e)
        when :ai_wait
          # change to attack
          attack_start(args, e)
        when :ai_attack_start
          # change to attack
          attack(args, e)
        when :ai_dying
          # remove from game
          @world.entities.delete(e)
        else
          log "[ENEMY AT] Unknown state change!!!"
          # type code here
        end
      end
    end
  end

  def pick_target
    if @world.barbarian.health.value > 0
      @world.barbarian
    else
      #@world.healer
      nil
    end
  end

  def wait(args, e)
    e.enemy_ai.state = :ai_wait
    e.enemy_ai.state_change_at = args.tick_count + 100 + rand(100)

    e.sprite.frame = 0
    e.sprite.state = :idle_1
    #log "[ENEMY AT] Change to wait."
  end

  def attack_start(args, e)
    e.enemy_ai.state = :ai_attack_start
    e.enemy_ai.state_change_at = args.tick_count + 70

    e.sprite.frame = 0
    e.sprite.state = :attack_1

    #log "[ENEMY AT] Change to attack_start."
  end

  def attack(args, e)
    e.enemy_ai.state = :ai_attack
    e.enemy_ai.state_change_at = args.tick_count + 70

    target = pick_target
    unless target.nil?
      args.sfx.play(:sword_attack_1)

      amount = e.attack_power.value - (e.attack_power.value * target.damage_reduction.value)
      target.take_damage(args, amount)

      @world.entities << TextEntity.new({
        position: {x: target.position.x + target.sprite.w.half - 24, y: target.position.y + target.sprite.h.half + 40 },
        acceleration: { y: -0.1 },
        velocity: { x: -4, y: 1 + rand(3) },
        text: { value: "-#{amount.trim}", delete_at: args.tick_count + 100, r: 255, g: 0, b: 0 }
      })
    end

    #log "[ENEMY AT] Change to attack."
  end
end