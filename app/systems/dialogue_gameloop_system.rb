#noinspection RubyNilAnalysis
class DialogueGameloopSystem < Draco::System
  filter Dialogue

  def tick(args)
    return if entities.empty?

    entities.each do |e|
      if e.dialogue.status == :not_started
        # one-time initialization
        e.dialogue.status = :in_progress
        e.dialogue.widget = DialogueWidget.new(args, e.dialogue)
        log "[DIALOGUE] Starting."

        unless @world.calendar.day.day_num == 0
          @world.reset
          args.sfx.loop_fade_out(:dead_1, 1.seconds)
          args.sfx.loop(:combat_1) unless args.sfx.looping?(:combat_1)
        end
      end

      # darken background
      args.outputs.primitives << {
        x: 0,
        y: 0,
        w: args.grid.w,
        h: args.grid.h,
        a: 128,
      }.solid!

      if e.dialogue.status != :done
        # processing
        widget = e.dialogue.widget
        widget.handle_input(args)
        widget.track(args)
        widget.render(args)
      else
        # cleanup
        log "[DIALOGUE] Done."
        @world.entities.delete(e)
        @world.systems.delete(DialogueGameloopSystem)

        if @world.calendar.day.day_num == 0
          @world.transition_to_tutorial(args)
        else
          #args.sfx.play!(:cinematic_hit_1)
          @world.systems << LevelSetupSystem
        end
      end
    end
  end

end