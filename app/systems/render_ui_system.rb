#noinspection RubyNilAnalysis,RubyResolve
class RenderUiSystem < Draco::System

  filter UiActionButton

  def tick(args)
    draw_spell_buttons(args)
    draw_event_bar(args)

    draw_enemy_status_bars(args)
    draw_hero_status_bars(args)
  end

  def draw_hero_status_bars(args)
    base_offset_x = 32
    base_offset_y = 548
    portrait_size = 64
    status_bar_height = 16

    @world.entities[Hero,Portrait].each do |e|
      status_bar_width = e.health.max_value * 12.0
      args.outputs.primitives << {
        x: 0 + base_offset_x + portrait_size - 4,
        y: 0 + base_offset_y + status_bar_height.half + 8,
        w: status_bar_width,
        h: status_bar_height,
        g: 128,
        r: 128,
        b: 128
      }.solid!

      args.outputs.primitives << {
        x: 0 + base_offset_x + portrait_size - 4,
        y: 0 + base_offset_y + status_bar_height.half + 8,
        w: status_bar_width * (e.health.value.to_f / e.health.max_value.to_f),
        h: status_bar_height,
        g: 160
      }.solid!

      args.outputs.primitives << {
        x: 0 + base_offset_x + portrait_size + 4, # - 4 + status_bar_width.half,
        y: 0 + base_offset_y + status_bar_height.half + 8,
        text: (e.health.value + 0.01).round(1),
        size_enum: -4,
        alignment_enum: 0,
        vertical_alignment_enum: 0,
        font: $font_body,
        r: 255,
        g: 255,
        b: 255,
        a: 255,
      }.label!

      args.outputs.primitives << {
        x: 0 + base_offset_x,
        y: 0 + base_offset_y,
        w: portrait_size,
        h: portrait_size,
        tile_x: e.portrait.tile_x,
        tile_y: e.portrait.tile_y,
        tile_w: e.portrait.tile_w,
        tile_h: e.portrait.tile_h,
        path: e.portrait.path
      }.sprite!
    end
  end

  def draw_enemy_status_bars(args)
    base_offset_x = args.grid.w - 40
    base_offset_y = 572
    portrait_size = 40
    status_bar_height = 16

    @world.entities[Enemy,Portrait].each do |e|
      status_bar_width = e.health.max_value * 12.0
      args.outputs.primitives << {
        x: base_offset_x - portrait_size - status_bar_width + 4,
        y: base_offset_y + status_bar_height.half + 4,
        w: status_bar_width,
        h: status_bar_height,
        g: 128,
        r: 128,
        b: 128
      }.solid! # gray bar

      args.outputs.primitives << {
        x: base_offset_x - portrait_size - (status_bar_width * (e.health.value.to_f / e.health.max_value.to_f)) + 4,
        y: base_offset_y + status_bar_height.half + 4,
        w: status_bar_width * (e.health.value.to_f / e.health.max_value.to_f),
        h: status_bar_height,
        g: 160
      }.solid!

      args.outputs.primitives << {
        x: base_offset_x - portrait_size - 0, # - portrait_size - 24, # - status_bar_width.half + 4,
        y: 0 + base_offset_y + status_bar_height.half + 4,
        text: (e.health.value + 0.01).round(1),
        size_enum: -4,
        alignment_enum: 2,
        vertical_alignment_enum: 0,
        font: $font_body,
        r: 255,
        g: 255,
        b: 255,
        a: 255,
      }.label!

      args.outputs.primitives << {
        x: base_offset_x - portrait_size,
        y: base_offset_y,
        w: portrait_size,
        h: portrait_size,
        tile_x: e.portrait.tile_x,
        tile_y: e.portrait.tile_y,
        tile_w: e.portrait.tile_w,
        tile_h: e.portrait.tile_h,
        path: e.portrait.path
      }.sprite!

      base_offset_y -= 56
    end
  end

  def draw_event_bar(args)
    # draw event bar
    #
    border = 40
    height = 24
    events_rect = {
      x: border,
      y: args.grid.h - (border + height),
      w: args.grid.w - border * 2,
      h: height,
    }
    args.outputs.primitives << {
      **events_rect,
      r: 78,
      g: 102,
      b: 102
    }.solid!

    # Base time calculations
    #
    time_passed = args.tick_count - @world.level.level_progress.started_at
    time_passed = 0 if @world.level.level_progress.started_at == 0
    time_total = @world.level.level_progress.ends_at - @world.level.level_progress.started_at

    # draw level events
    #
    @world.level.level_progress.events.each do |e|
      pct_of_rect = e.at.to_f / time_total.to_f
      last_x = (events_rect.x + events_rect.w * pct_of_rect).clamp(0, events_rect.x + events_rect.w)

      args.outputs.primitives << {
        x: last_x,
        y: events_rect.y - 4,
        w: 2,
        h: height + 8,
        r: 128,
        g: 192,
        b: 192
      }.solid!
    end

    # draw 'now' tick
    #
    pct_of_rect = time_passed.to_f / time_total.to_f
    if @world.level.level_progress.state == :in_progress
      last_x = (events_rect.x + events_rect.w * pct_of_rect).clamp(0, events_rect.x + events_rect.w)
      @world.level.level_progress.ended_at = last_x
    else
      last_x = @world.level.level_progress.ended_at
    end

    args.outputs.primitives << {
      x: last_x,
      y: events_rect.y - 4,
      w: 4,
      h: height + 8,
      r: 255,
      g: 255,
      b: 255
    }.solid!
  end

  def draw_spell_buttons(args)
    entities.each do |e|
      s = e.sprite
      b = e.button

      args.outputs.primitives << {
        x: e.position.x,
        y: e.position.y,
        w: s.w,
        h: s.h,
        tile_x: s.tile_x,
        tile_y: s.tile_y,
        tile_w: s.tile_w,
        tile_h: s.tile_h,
        path: (b.enabled && b.cooldown <= 0) ? s.path : s.path_disabled,
        angle: s.angle
      }.sprite! # graphic

      if e.button.selected
        args.outputs.primitives << {
          x: e.position.x,
          y: e.position.y,
          w: e.sprite.w,
          h: e.sprite.h,
          r: 255
        }.border! # selected outline (not used)
      end

      if e.button.cooldown > 0
        args.outputs.primitives << {
          x: e.position.x + e.sprite.w.half + 1,
          y: e.position.y + 20,
          text: (e.button.cooldown.idiv(1.seconds) + 1).to_s,
          size_enum: -1,
          alignment_enum: 1,
          vertical_alignment_enum: 0,
          font: $font_title_mono,
          r: 0,
          g: 0,
          b: 0,
          a: 255,
        }.label! # cooldown
      end

      args.outputs.primitives << {
        x: e.position.x + e.sprite.w.half,
        y: e.position.y - 20,
        text: e.button.key.to_s,
        size_enum: -5,
        alignment_enum: 1,
        vertical_alignment_enum: 0,
        font: $font_title_mono,
        r: 255,
        g: 255,
        b: 255,
        a: 255,
      }.label! # text for keyboard number
    end

    # draw mouseovers (buttons)
    # @world.entities[ClickTarget].each do |e|
    #   if args.inputs.mouse.inside_rect? e.rect
    #     args.outputs.primitives << {
    #       x: e.position.x,
    #       y: e.position.y,
    #       w: e.sprite.w,
    #       h: e.sprite.h,
    #       b: 255
    #     }.border!
    #   end
    # end

    # draw selected spell button
    entities.each do |e|
      if e.button.selected
        args.outputs.primitives << {
          x: e.position.x,
          y: e.position.y,
          w: e.sprite.w,
          h: e.sprite.h,
          r: 255
        }.border!
      end
    end

  end
end