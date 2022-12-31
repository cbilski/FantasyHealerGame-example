#noinspection RubyNilAnalysis,RubyResolve
class RenderHeroSpritesSystem < Draco::System

  def tick(args)
    #avatar = entities.first # use with "filter PlayerAvatar"
    avatar = @world.healer
    args.state.player = avatar
    render_healer(args, avatar.position, avatar.sprite)

    avatar = @world.barbarian
    args.state.barbarian = avatar
    render_barbarian(args, avatar.position, avatar.sprite)
  end

  def render_healer(args, position, sprite)
    states = {
      idle_1:    { file_name: 'IDLE ',     frames: 4, interval: 12},
      attack_1:  { file_name: 'ATTACK ',   frames: 3, interval: 12},
      attack_2:  { file_name: 'S ATTACK ', frames: 3, interval: 12},
      defeat_1:  { file_name: 'DEFEAT ',   frames: 3, interval: 72},
      hit_1:     { file_name: 'HIT ',      frames: 4, interval: 12},
      fall_1:    { file_name: 'FALL ',     frames: 3, interval: 12},
      hurt_1:    { file_name: 'HURT ',     frames: 3, interval: 12},
      jump_1:    { file_name: 'JUMP ',     frames: 4, interval: 12},
      pick_up_1: { file_name: 'PICK UP ',  frames: 2, interval: 12},
      pull_1:    { file_name: 'PULL ',     frames: 4, interval: 12},
      push_1:    { file_name: 'PUSH ',     frames: 4, interval: 12},
      walk_1:    { file_name: 'WALK ',     frames: 4, interval: 12},
      #          hit_2: { file_name: 'B HIT ', frames: 4}, # book hit
      # attack1_effect: { file_name: 'B ATTACK ', frames: 3}, # book attack
      # attack2_effect: { file_name: 'SP ATTACK ', frames: 3}, # attack effect
    }

    if sprite.state != sprite.last_state
      log "[HEALER] State change from #{sprite.last_state} to #{sprite.state}"
      sprite.last_state = sprite.state
      sprite.frame = 0 # this will get updated to 0 later
    end

    state = sprite.state # :idle_1 #component

    width = sprite.w
    height = sprite.h
    zoom = sprite.zoom
    frame = sprite.frame

    is_defeated = true
    if state == :defeat_1 && frame == states[state].frames - 1
      # do nothing
    else
      is_defeated = false
      sprite.frame = (sprite.frame + 1) % states[state].frames if args.tick_count.zmod?(states[state].interval)  #component
    end

    args.outputs.primitives << {
      x: position.x,
      y: position.y,
      w: width * zoom,
      h: height * zoom,
      tile_x: 0,
      tile_y: 0,
      tile_w: 320,
      tile_h: 320,
      angle: 0,
      path: "/sprites/heroes/azuna-pixels.itch.io/SORCERESS/#{states[state].file_name}#{frame + 1}.png",
      r: is_defeated ? 64 : 255,
      g: is_defeated ? 64 : 255,
      b: is_defeated ? 64 : 255,
    }.sprite!

    # args.outputs.primitives << {
    #   x: avatar.position.x,
    #   y: avatar.position.y,
    #   w: width * zoom,
    #   h: width * zoom,
    #   b: 255
    # }.border!
  end

  def render_barbarian(args, position, sprite)
    states = {
         idle_1: { file_name: 'IDLE ',     frames: 4, interval: 12},
       attack_1: { file_name: 'ATTACK ',   frames: 3, interval: 12},
       attack_2: { file_name: 'S ATTACK ', frames: 4, interval: 12},
       defeat_1: { file_name: 'DEFEAT ',   frames: 3, interval: 72},
         fall_1: { file_name: 'FALL ',     frames: 3, interval: 12},
          hit_1: { file_name: 'AXE HIT ',  frames: 3, interval: 12},
         hurt_1: { file_name: 'HURT ',     frames: 3, interval: 12},
         jump_1: { file_name: 'JUMP ',     frames: 4, interval: 12},
      pick_up_1: { file_name: 'PICK UP ',  frames: 2, interval: 12},
         pull_1: { file_name: 'PULL ',     frames: 5, interval: 12},
         push_1: { file_name: 'PUSH ',     frames: 5, interval: 12},
         walk_1: { file_name: 'WALK ',     frames: 4, interval: 12},
    }

    if sprite.state != sprite.last_state
      #log "[BARBARIAN] State change from #{sprite.last_state} to #{sprite.state}"
      sprite.last_state = sprite.state
      sprite.frame = 0 # this will get updated to 0 later
    end

    state = sprite.state # :idle_1 #component
    width = sprite.w
    height = sprite.h
    zoom = sprite.zoom
    frame = sprite.frame

    is_defeated = true
    if state == :defeat_1 && frame == states[state].frames - 1
      # do nothing
    else
      is_defeated = false
      sprite.frame = (sprite.frame + 1) % states[state].frames if args.tick_count.zmod?(states[state].interval)  #component
    end

    y_offset = -8
    x_offset = 0

    if state == :hurt_1
      amount = 6
      x_offset += rand(amount) - amount.half
      y_offset += rand(amount) - amount.half
    end

    args.outputs.primitives << {
      x: position.x + x_offset,
      y: position.y + y_offset,
      w: width * zoom,
      h: height * zoom,
      tile_x: 0,
      tile_y: 0,
      tile_w: 320,
      tile_h: 320,
      angle: 0,
      path: "/sprites/heroes/azuna-pixels.itch.io/BARBARIAN/#{states[state].file_name}#{frame + 1}.png",
      r: is_defeated ? 64 : 255,
      g: is_defeated ? 64 : 255,
      b: is_defeated ? 64 : 255,
    }.sprite!

    # args.outputs.primitives << {
    #   x: avatar.position.x,
    #   y: avatar.position.y,
    #   w: width * zoom,
    #   h: width * zoom,
    #   b: 255
    # }.border!
  end

end