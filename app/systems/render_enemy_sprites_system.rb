#noinspection RubyNilAnalysis,RubyResolve
class RenderEnemySpritesSystem < Draco::System
  filter Enemy

  def tick(args)
    return if entities.empty?

    states = {
        idle_1: { dir_name: 'IDLEleft',   frames:  8, interval: 90, tile_x: 0, tile_y:  0, tile_w: 192, tile_h: 192, scale_w: 1, x_offset: 0 },
      defeat_1: { dir_name: 'IDLEleft',   frames:  8, interval: 10, tile_x: 0, tile_y:  0, tile_w: 192, tile_h: 192, scale_w: 1, x_offset: 0 },
        walk_1: { dir_name: 'WALKleft',   frames: 12, interval: 10, tile_x: 0, tile_y:  0, tile_w: 192, tile_h: 192, scale_w: 1, x_offset: 0 },
      attack_1: { dir_name: 'ATTACKleft', frames: 14, interval: 10, tile_x: 0, tile_y: 96, tile_w: 384, tile_h: 192, scale_w: 2, x_offset: -240 },
    }

    enemies = []
    entities.each { |e| enemies.insert(0, e) } # need to reverse the draco order

    enemies.each do |enemy|
      sprite = enemy.sprite
      state = states[sprite.state]
      sprite.frame = (sprite.frame + 1) % state.frames if args.tick_count.zmod?(state.interval)  #component

      path = "/sprites/enemies/Toomask-gdm/SKELETON/#{state.dir_name}/skeleton (#{sprite.frame + 1}).png"

      alpha = 255
      y_offset = 8
      x_offset = state.x_offset * sprite.scale

      if sprite.shake_until > args.tick_count
        amount = 6
        x_offset += rand(amount) - amount.half
        y_offset += rand(amount) - amount.half
      end

      if sprite.fade_at > 0
        alpha = 255 * (1 - sprite.fade_at.ease(sprite.fade_duration))
      end

      flash = 1
      if sprite.flash_at > 0
        flash = sprite.flash_at.ease(sprite.flash_duration)
      end

      grow = 4
      args.outputs.primitives << {
        x: enemy.position.x + grow + x_offset,
        y: enemy.position.y + grow + y_offset,
        w: enemy.sprite.w * state.scale_w,
        h: enemy.sprite.h,
        tile_x: state.tile_x,
        tile_y: state.tile_y,
        tile_w: state.tile_w,
        tile_h: state.tile_h,
        path: path,
        r: 64, g: 0, b: 0, a: alpha
      }.sprite!

      args.outputs.primitives << {
        x: enemy.position.x - grow + x_offset,
        y: enemy.position.y + grow + y_offset,
        w: enemy.sprite.w * state.scale_w,
        h: enemy.sprite.h,
        tile_x: state.tile_x,
        tile_y: state.tile_y,
        tile_w: state.tile_w,
        tile_h: state.tile_h,
        path: path,
        r: 64, g: 0, b: 0, a: alpha
      }.sprite!

      args.outputs.primitives << {
        x: enemy.position.x + grow + x_offset,
        y: enemy.position.y - grow + y_offset,
        w: enemy.sprite.w * state.scale_w,
        h: enemy.sprite.h,
        tile_x: state.tile_x,
        tile_y: state.tile_y,
        tile_w: state.tile_w,
        tile_h: state.tile_h,
        path: path,
        r: 64, g: 0, b: 0, a: alpha
      }.sprite!

      args.outputs.primitives << {
        x: enemy.position.x - grow + x_offset,
        y: enemy.position.y - grow + y_offset,
        w: enemy.sprite.w * state.scale_w,
        h: enemy.sprite.h,
        path: path,
        tile_x: state.tile_x,
        tile_y: state.tile_y,
        tile_w: state.tile_w,
        tile_h: state.tile_h,
        r: 64, g: 0, b: 0, a: alpha
      }.sprite!

      args.outputs.primitives << {
        x: enemy.position.x + x_offset,
        y: enemy.position.y + y_offset,
        w: enemy.sprite.w * state.scale_w,
        h: enemy.sprite.h,
        tile_x: state.tile_x,
        tile_y: state.tile_y,
        tile_w: state.tile_w,
        tile_h: state.tile_h,
        path: path,
        r: enemy.sprite.r * flash,
        g: enemy.sprite.g * flash,
        b: enemy.sprite.b * flash,
        a: alpha
      }.sprite!

      # args.outputs.primitives << {
      #   x: enemy.position.x,
      #   y: enemy.position.y,
      #   w: enemy.sprite.w,
      #   h: enemy.sprite.h,
      #   b: 255
      # }.border!
    end
  end

end