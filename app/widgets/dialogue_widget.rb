class DialogueWidget
  def initialize(args, context)
    @context = context
    @dialog_id = context.id
    @dialog_index = 0
    @dialog_start_at = args.tick_count
    @dialog = CharacterDialog.create_dialog(@dialog_id)
    @dialog_part_completed = false
    @partial_text_completed = false # set/reset each partial_text call
    @partial_text_started = false
  end

  def advance_dialog_part(args)
    @dialog_index += 1
    @dialog_start_at = args.tick_count
    @dialog_part_completed = false
    @partial_text_started = false
  end

  def finished?
    # return true if this widget is done doing things (and parent should clean up)
    @context.status == :done
  end

  def handle_input(args)
    @dialog_part_completed = @partial_text_completed

    # input logic goes here
    # on input, advance dialog
    input_detected = args.inputs.keyboard.key_up.enter || args.inputs.controller_one.key_up.b
    if input_detected && @dialog_part_completed
      advance_dialog_part(args)
    elsif input_detected && !@dialog_part_completed
      @dialog_start_at = -9999 # force dialog text to complete
      #@dialog_index = @dialog.length - 1
    elsif @dialog_index >= @dialog.length
      # completes all dialog (not part)
      @context.status = :done
    end
  end

  def modal?
    # return true if this should pause game
    true
  end

  def partial_text(args, text, speed)
    elapsed = args.tick_count - @dialog_start_at
    num_chars = (elapsed / speed).to_i

    if num_chars < text.length
      @partial_text_completed = false

      unless @partial_text_started
        @partial_text_started = true #SFX Start
        args.sfx.loop :dialogue_text_1
      end

      text[0, num_chars]
    else
      @partial_text_completed = true

      if @partial_text_started
        @partial_text_started = false #SFX Stop
        args.sfx.stop! :dialogue_text_1 # TBD: issue with multiple loops and music (loop/looping_now? should support optional type argument)
      end

      text
    end
  end

  def render(args)
    dialog = @dialog[@dialog_index]
    return if dialog.nil?

    #text_draw_speed = 3.5
    text_draw_speed = 2.5
    @font_name = $font_title
    @dialog = CharacterDialog.create_dialog(@dialog_id)

    base_x = 192
    base_y = 64
    base_w = 1280 - (192 * 2)
    base_h = 192

    args.outputs.primitives << {
      x: base_x,
      y: base_y,
      w: base_w,
      h: base_h,
      r: 159, g: 102, b: 50, # dark brown
      a: 255,
    }.solid! # outer border

    base_border = 4
    args.outputs.primitives << {
      x: base_x + base_border,
      y: base_y + base_border,
      w: base_w - base_border * 2,
      h: base_h - base_border * 2,
      r: 252, g: 221, b: 178, # very light
      a: 255,
    }.solid! # inner border

    base_border = 8
    args.outputs.primitives << {
      x: base_x + base_border,
      y: base_y + base_border,
      w: base_w - base_border * 2,
      h: base_h - base_border * 2,
      r: 218, g: 169, b: 117, # parchment
      a: 255,
    }.solid! # background

    if dialog.portrait == :player
      portrait_size = base_h - base_border * 2
      args.outputs.primitives << {
        x: base_x + base_border,
        y: base_y + base_border,
        w: portrait_size,
        h: portrait_size,
        tile_x: 32, tile_y: 48, tile_w: 240, tile_h: 240,
        path: '/sprites/heroes/azuna-pixels.itch.io/SORCERESS/ATTACK 2.png',
      }.sprite!

      render_text(
        args,
        {
          x: base_x + portrait_size,
          y: base_y - 4,
          w: base_w,
          h: portrait_size},
        partial_text(args, dialog.text, text_draw_speed),
        0, # three-lines = 12, four-lines = 8
        @font_name,
        { r: 0, g: 0, b: 0})

      hint_h = 12 * 3
      hint_w = 28 * 3
      hint_frame = (args.tick_count.idiv(30) % 2)
      hint_tileset_x = hint_frame == 0 ? 146 : 174
      args.outputs.primitives << {
        x: base_x + base_w - hint_w - base_border - 4,
        y: base_y + base_border,
        w: hint_w,
        h: hint_h,
        tile_x: hint_tileset_x, tile_y: 180, tile_w: 28, tile_h: 12,
        path: '/sprites/retrocademedia.itch.io-Keyboard Prompts.png',
      }.sprite!
    end

    if dialog.portrait == :npc1
      portrait_size = base_h - base_border * 2
      args.outputs.primitives << {
        x: base_x + base_border,
        y: base_y + base_border,
        w: portrait_size,
        h: portrait_size,
        tile_x: 32, tile_y: 48, tile_w: 240, tile_h: 240,
        path: '/sprites/heroes/azuna-pixels.itch.io/BARBARIAN/WALK 2.png',
      }.sprite!

      render_text(
        args,
        {
          x: base_x + portrait_size,
          y: base_y,
          w: base_w,
          h: portrait_size},
        partial_text(args, dialog.text, text_draw_speed),
        0, # three-lines = 12, four-lines = 8
        @font_name,
        { r: 0, g: 0, b: 0})

      hint_h = 12 * 3
      hint_w = 28 * 3
      hint_frame = (args.tick_count.idiv(30) % 2)
      hint_tileset_x = hint_frame == 0 ? 146 : 174
      args.outputs.primitives << {
        x: base_x + base_w - hint_w - base_border - 4,
        y: base_y + base_border,
        w: hint_w,
        h: hint_h,
        tile_x: hint_tileset_x, tile_y: 180, tile_w: 28, tile_h: 12,
        path: '/sprites/retrocademedia.itch.io-Keyboard Prompts.png',
      }.sprite!
    end

    if dialog.portrait == :skeleton
      portrait_size = base_h - base_border * 2
      if $flags[:hide_boss] == true
        args.outputs.primitives << {
          x: base_w + base_border,
          y: base_y + base_border,
          w: base_h - base_border * 2,
          h: base_h - base_border * 2,
          r: 0, g: 0, b: 255,
        }.solid!
      else
        args.outputs.primitives << {
          x: base_w + base_border,
          y: base_y + base_border,
          w: base_h - base_border * 2,
          h: base_h - base_border * 2,
          tile_x: 36, tile_y: 0, tile_w: 176, tile_h: 176,
          #r: 192, g: 192, b: 192,
          path: '/sprites/enemies/Toomask-gdm/SKELETON/PORTRAIT/skeletonPORTRAITleft.png',
        }.sprite!
      end

      render_text(
        args,
        {
          x: base_x + 12,
          y: base_y,
          w: base_w - portrait_size - 32, # 32 is magic...
          h: portrait_size},
        partial_text(args, dialog.text, text_draw_speed),
        0, # three-lines = 12, four-lines = 8
        @font_name,
        { r: 0, g: 0, b: 0})

      hint_h = 12 * 3
      hint_w = 28 * 3
      hint_frame = (args.tick_count.idiv(30) % 2)
      hint_tileset_x = hint_frame == 0 ? 146 : 174
      args.outputs.primitives << {
        x: base_x + base_w - hint_w - base_border - 4 - portrait_size,
        y: base_y + base_border,
        w: hint_w,
        h: hint_h,
        tile_x: hint_tileset_x, tile_y: 180, tile_w: 28, tile_h: 12,
        path: '/sprites/retrocademedia.itch.io-Keyboard Prompts.png',
      }.sprite!
    end
  end

  def render_text(args, rect, text, font_size, font, panel_text_color)
    # Lazy implementation of word wrapping for our render pipeline
    work = ""
    len = text.length
    font_padding_y = 20
    font_h = args.gtk.calcstringbox(text, font_size, font).y + font_padding_y
    y_offset = 10
    x_offset = 8
    i = 0

    while i < len
      x_len = args.gtk.calcstringbox(work + text[i], font_size, font).x

      if x_len >= rect.w || text[i] == "\n"
        args.outputs.primitives << {
          x: rect.x + x_offset, y: (rect.y + rect.h) - y_offset,
          text: work, size_enum: font_size,
          alignment_enum: 0, vertical_alignment_enum: 2,
          font: font,
          **panel_text_color,
        }.label!

        work = text[i]
        y_offset += font_h
      else
        work += text[i]
      end
      i += 1
    end

    if work.length > 0
      args.outputs.primitives << {
        x: rect.x + x_offset, y: (rect.y + rect.h) - y_offset,
        text: work, size_enum: font_size,
        alignment_enum: 0, vertical_alignment_enum: 2,
        font: font,
        **panel_text_color,
      }.label!
    end
  end

  def track(args)
    # update logic goes here
    if $gtk.production == false
      args.state.scene.widgets.dialog.dialog_start_at = @dialog_start_at if args.tick_count.zmod?(10)
      args.state.scene.widgets.dialog.dialog_index = @dialog_index if args.tick_count.zmod?(10)
    end
  end
end