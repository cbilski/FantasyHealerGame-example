require '/lib/draco.rb'
require '/app/args.rb'
require '/app/sfx.rb'
require '/app/app.rb'
require '/app/monkey.rb'
require '/app/components/tags.rb'
require '/app/components/acceleration.rb'
require '/app/components/attack_power.rb'
require '/app/components/button.rb'
require '/app/components/boon.rb'
require '/app/components/damage_reduction.rb'
require '/app/components/day.rb'
require '/app/components/dialogue.rb'
require '/app/components/enemy_ai.rb'
require '/app/components/health.rb'
require '/app/components/heal_power.rb'
require '/app/components/cure_power.rb'
require '/app/components/smite_power.rb'
require '/app/components/stun_power.rb'
require '/app/components/hero_ai.rb'
require '/app/components/portrait.rb'
require '/app/components/position.rb'
require '/app/components/level_progress.rb'
require '/app/components/sprite.rb'
require '/app/components/text.rb'
require '/app/components/velocity.rb'
require '/app/entities/boon_entity.rb'
require '/app/entities/dialogue_entity.rb'
require '/app/entities/calendar_entity.rb'
require '/app/entities/hero_entity.rb'
require '/app/entities/healer_entity.rb'
require '/app/entities/enemy_entity.rb'
require '/app/entities/level_entity.rb'
require '/app/entities/spell_effect_entity.rb'
require '/app/entities/text_entity.rb'
require '/app/entities/ui_action_button_entity.rb'
require '/app/object_model/character_dialogue.rb'
require '/app/widgets/dialogue_widget.rb'
require '/app/systems/boon_gameloop_system.rb'
require '/app/systems/death_gameloop_system.rb'
require '/app/systems/dialogue_gameloop_system.rb'
require '/app/systems/level_enemy_ai_system.rb'
require '/app/systems/level_hero_ai_system.rb'
require '/app/systems/level_gameloop_system.rb'
require '/app/systems/level_setup_system.rb'
require '/app/systems/level_user_input_system.rb'
require '/app/systems/render_background_system.rb'
require '/app/systems/render_enemy_sprites_system.rb'
require '/app/systems/render_hero_sprites_system.rb'
require '/app/systems/render_spell_effects_system.rb'
require '/app/systems/render_text_system.rb'
require '/app/systems/render_ui_system.rb'
require '/app/systems/render_debug_system.rb'
require '/app/systems/tutorial_gameloop_system.rb'
require '/app/systems/win_gameloop_system.rb'
require '/app/scenes/splash_scene.rb'
require '/app/scenes/game_scene_i.rb'

def tick args
  if $flags.nil?
    $flags = {}
    argv = $gtk.argv.split(" ")
    argv.each do |part|
      if part.start_with?("--")
        part = part[2..-1]
        $flags[part.to_sym] = true
      end
    end
  end

  # #args.gtk.log_level = :off

  @app ||= GameApp.new
  @version ||= $wizards.itch.get_metadata[:version]
  $app ||= @app
  args.sfx ||= Sfx.new(args)
  #
  @app.tick(args)
  args.sfx.tick(args)
  #
  # # unless $flags.show_mouse == true
  # #   $gtk.hide_cursor
  # # end
  #
  state = args.state
  state.game_start_datetime ||= Time.now

  args.outputs.primitives << {
    x: 4,
    y: 715,
    text: "#{Time.now}; Ticks: #{state.tick_count}; Frames: #{$gtk.current_framerate.idiv(1)}; DragonRuby v#{$gtk.version} (#{$gtk.platform}); Version: #{@version}; Elapsed: #{((Time.now - state.game_start_datetime) / 60.0).round(3)}m",
    size_enum: -2,
    alignment_enum: 0,
    vertical_alignment_enum: 2,
    font1: @font_name,
    r: 255,
    g: 255,
    b: 255,
    a: 255,
  }.label! if $gtk.production == false
end
