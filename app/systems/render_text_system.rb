#noinspection RubyNilAnalysis,RubyResolve
class RenderTextSystem < Draco::System
  filter Text,Position,Acceleration,Velocity

  def tick(args)
    entities.each do |e|
      args.outputs.primitives << {
        x: e.position.x,
        y: e.position.y,
        text: e.text.value,
        size_enum: -1,
        alignment_enum: 1,
        vertical_alignment_enum: 1,
        font: $font_body,
        r: e.text.r,
        g: e.text.g,
        b: e.text.b,
        a: 255,
      }.label!

      e.position.x += e.velocity.x
      e.position.y += e.velocity.y

      e.velocity.x += e.acceleration.x
      e.velocity.y += e.acceleration.y

      @world.entities.delete(e) if e.text.delete_at <= args.tick_count
    end
  end
end