class GameApp
  attr_reader :scene
  attr_reader :scenes

  def initialize
    # setup scenes
    @scenes = {}
    @scenes[:splash] = SplashScene.new(:splash, @gom)
    init_game_scene

    if $flags.no_splash == true
      transition_to(:game_scene_i)
    else
      transition_to(:splash)
    end

    $gtk.set_window_fullscreen(true) if $flags[:fullscreen]

    $font_body = "/fonts/ManaSeedBody.ttf"
    $font_title = "/fonts/ManaSeedTitle.ttf"
    $font_title_mono = "/fonts/ManaSeedTitleMono.ttf"
  end

  def init_game_scene
    @scenes[:game_scene_i] = GameScene1.new(:game_scene_i)
  end

  def tick(args)
    @scene.tick(args)
  end

  def transition_to(scene_id, args = nil)
    @scene.scene_deactivate args if @scene != nil
    @scene = @scenes[scene_id]
    @scene.scene_activate args if @scene != nil

    $scene = @scene
  end
end

module GTK
  class Runtime
    module Framerate
      def xx_check_framerate
        # suppress framerate message
      end
    end
  end
end

module GTK
  class Runtime
    module Framerate
      def xx_framerate_below_threshold?
        false
      end
    end
  end
end
