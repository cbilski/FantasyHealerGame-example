#noinspection RubyNilAnalysis
class WinGameloopSystem < Draco::System

  def tick(args)
    args.outputs.primitives << {
      x: 0,
      y: 0,
      w: args.grid.w,
      h: args.grid.h,
      a: 192,
    }.solid!

    text = [
      "Healer, we have won the day!",
      "",
      "Your persistence and skill have saved us all.",
      "The world can never truly understand your sojourn:",
      "But it *exists* now on because of you!",
      "",
      "(ENTER or SPACE to continue)",
    ]

    y_base = args.grid.h.half + 128
    y_offset = 0

    text.each do |t|
      args.outputs.primitives << {
        x: args.grid.w.half,
        y: y_base - y_offset,
        text: t,
        size_enum: -1,
        alignment_enum: 1,
        vertical_alignment_enum: 1,
        font: $font_title,
        r: 255,
        g: 255,
        b: 255,
        a: 255,
      }.label!

      y_offset += 48
    end

    # args.outputs.primitives << {
    #   x: 0,
    #   y: 0,
    #   w: args.grid.w,
    #   h: args.grid.h.half,
    #   r: 255,
    #   g: 255,
    #   b: 255,
    # }.border!

    if args.inputs.keyboard.key_up.enter || args.inputs.keyboard.key_up.space # || args.inputs.mouse.click
      @world.transition_to_boon(args)
    end
  end

end