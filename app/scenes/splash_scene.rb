class SplashScene
  attr_reader :id

  def initialize(id, gom)
    @id = id
    @gom = gom
    @pipeline = []
    @transition_to = :game_scene_i

    reset
  end

  def scene_activate(args)

  end

  def scene_deactivate(args)
  end

  def reset
    @alpha = 0
    @alpha_factor = 255 / 60
    @zoom = 0
    @zoom_factor = 100.to_f / 60.to_f

    #target_values = { r: 0, g: 0, b: 0 }
    target_values = { r: 32, g: 32, b: 32 }
    @back_color_values = { r: 255, g: 255, b: 255 }
    @back_color_factors = { r: (255 - target_values[:r]) / 120.0, g: (255 - target_values[:g]) / 120.0, b: (255 - target_values[:b]) / 120.0 }
    @back_color_timer = 0

    @wait_time = 0
    @transition1_played = false
    @transition2_played = false
  end

  def render_pipeline(args)
    args.outputs.primitives << @pipeline
    @pipeline.clear
  end

  def tick(args)
    # if args.inputs.keyboard.key_up.escape
    #   reset
    #   @gom.app.transition_to(@transition_to, args)
    #   return
    # end

    @music_started ||= :not_started
    if args.tick_count > 5 && @music_started == :not_started
      args.sfx.loop_fade_in(:combat_1, 5.seconds)
      @music_started = :started
    end

    #do actual scene stuff
    zoom = @zoom / 100.0
    @pipeline << [0, 0, args.grid.w, args.grid.h, @back_color_values[:r], @back_color_values[:g], @back_color_values[:b]].solid

    @pipeline << {
      x: 0, y: 0, w: args.grid.w / zoom, h: args.grid.h / zoom, # make small helicoper 4 times bigger
      path: "/sprites/icon.png",
      angle: 0,
      a: @alpha, r: 255, g: 255, b: 255,
      tile_x: 0, tile_y: 168, tile_w: 1024, tile_h: 720,
      flip_vertically: false, flip_horizontally: false,
    }

    @alpha = @alpha + @alpha_factor # alpha/zoom are synched
    @alpha = 255 if (@alpha > 255)

    @zoom = @zoom + @zoom_factor
    @zoom = 100 if (@zoom > 100)

    @version ||= $wizards.itch.get_metadata[:version]
    @devtitle ||= $wizards.itch.get_metadata[:dev_title]

    @pipeline << {
      x: 1280 - 8,
      y: 32,
      text: "v#{@version.to_s} #{@devtitle} © 2022",
      size_enum: -2,
      alignment_enum: 2,
      vertical_alignment_enum: 2,
      font: $font_title,
      r: 255,
      g: 255,
      b: 255,
      a: 48,
    }.label!

    render_pipeline(args)

    unless @transition1_played
      args.sfx.play(:splash_transition_1)
      @transition1_played = true
    end

    if @alpha == 255
      if @wait_time < 30
        @wait_time = @wait_time + 1
      else
        unless @transition2_played
          args.sfx.play :splash_transition_2
          @transition2_played = true
        end

        if @back_color_timer < 120
          @back_color_timer = @back_color_timer + 1

          @back_color_values[:r] = @back_color_values[:r] - @back_color_factors[:r]
          @back_color_values[:g] = @back_color_values[:g] - @back_color_factors[:g]
          @back_color_values[:b] = @back_color_values[:b] - @back_color_factors[:b]
        elsif !args.sfx.playing?(:splash_transition_1) && !args.sfx.playing?(:splash_transition_2)
          reset
          args.sfx.stop! :splash_transition_2
          $app.transition_to(@transition_to, args) # TBD: find new home for app reference
        end
      end
    end
  end
end
