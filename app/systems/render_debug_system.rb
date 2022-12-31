#noinspection RubyNilAnalysis,RubyResolve
class RenderDebugSystem < Draco::System
  def tick(args)

    @world.entities[Health].each do |e|

      # # show health label
      # args.outputs.primitives << {
      #   x: e.position.x + e.sprite.w / 2,
      #   y: e.position.y,
      #   text: "[Health: #{e.health.value}]",
      #   size_enum: -2,
      #   alignment_enum: 1,
      #   vertical_alignment_enum: 0,
      #   r: 255,
      #   g: 255,
      #   b: 255,
      #   a: 255,
      # }.label!
      #
      # # show sprite state
      # args.outputs.primitives << {
      #   x: e.position.x + e.sprite.w / 2,
      #   y: e.position.y - 24,
      #   text: "[State: #{e.sprite.state}]",
      #   size_enum: -2,
      #   alignment_enum: 1,
      #   vertical_alignment_enum: 0,
      #   r: 255,
      #   g: 255,
      #   b: 255,
      #   a: 255,
      # }.label!

      # damage over time
      # e.health.value = (e.health.value - 0.1).clamp(0, e.health.max_value).round(2) if args.tick_count.zmod?(5)

      # make things die that are dead
      # if e.health.dead?
      #   e.sprite.state = :defeat_1
      # end
    end

  end
end