#noinspection RubyNilAnalysis,RubyResolve
class RenderSpellEffectsSystem < Draco::System
  filter(SpellEffect)

  def tick(args)
    entities.each do |e|
      if e.sprite.type == :light_1
        light_effect(args, e)
      elsif e.sprite.type == :air_impact_1
        air_impact_effect(args, e)
      end
    end
  end

  def light_effect(args, e)
    interval = 12 # run every 5 frames
    max_frames = 15

    # tick through each frame based on speed, remove entity when done
    frame = e.sprite.frame
    if args.tick_count.zmod?(interval)
      # advance frame
      e.sprite.frame += 1

      @world.entities.delete(e) if e.sprite.frame >= max_frames
    end

    e.position.y -= 0.5
    e.sprite.angle += 2
    e.sprite.alpha -= 3

    frame_rc = frame.divmod(13)
    args.outputs.primitives << {
      x: e.position.x,
      y: e.position.y,
      w: e.sprite.w,
      h: e.sprite.h,
      tile_x: frame_rc[1] * 48,
      tile_y: frame_rc[0] * 48,
      tile_w: 48,
      tile_h: 48,
      path: '/sprites/effects/light-sm/30FPS_ASLight_01_Cast.png',
      angle: e.sprite.angle,
      a: e.sprite.alpha
    #path: path,
    #r: 64, g: 0, b: 0
    }.sprite!
  end

  def air_impact_effect(args, e)
    interval = 12 # run every 5 frames
    max_frames = 8

    # tick through each frame based on speed, remove entity when done
    frame = e.sprite.frame
    if args.tick_count.zmod?(interval)
      # advance frame
      e.sprite.frame += 1

      @world.entities.delete(e) if e.sprite.frame >= max_frames
    end

    args.outputs.primitives << {
      x: e.position.x,
      y: e.position.y,
      w: e.sprite.w,
      h: e.sprite.h,
      path: "/sprites/effects/air-impactV001effect/air-impactV001effect00#{frame}.png",
    }.sprite!
  end
end