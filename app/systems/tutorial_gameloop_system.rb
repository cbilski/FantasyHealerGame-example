#noinspection RubyNilAnalysis
class TutorialGameloopSystem < Draco::System
  def tick(args)

    # hint setup
    @@hint_id ||= nil

    hints = {}
    if @world.level.level_progress.tutorial_id == :introduction
      hints = {
        1 => {
          text: "This is you. (ENTER or SPACE to continue)",
          alignment_enum: 1, vertical_alignment_enum: 0,
          text_offset_x: 144, text_offset_y: 0,
          x: @world.healer.position.x, y: @world.healer.position.y, w: @world.healer.sprite.w, h: @world.healer.sprite.h
        },
        2 => {
          text: "These are your spells.",
          alignment_enum: 1, vertical_alignment_enum: 0,
          text_offset_x: 0, text_offset_y: 0,
          x: 16, y: 0, w: 300, h: 96
        },
        3 => {
          text: "Only Healing Touch is unlocked.",
          alignment_enum: 0, vertical_alignment_enum: 0,
          text_offset_x: -36, text_offset_y: 0,
          x: 16, y: 0, w: 80, h: 96
        },
        4 => {
          text: "(You'll have opportunities to unlock more as the game progresses.)",
          alignment_enum: 0, vertical_alignment_enum: 0,
          text_offset_x: -172, text_offset_y: 0,
          x: 92, y: 0, w: 216, h: 96
        },
        5 => { text: "This is the village warrior.",
          alignment_enum: 1, vertical_alignment_enum: 0,
          text_offset_x: 0, text_offset_y: 0,
          x: @world.barbarian.position.x, y: @world.barbarian.position.y, w: @world.barbarian.sprite.w, h: @world.barbarian.sprite.h
        },
        6 => { text: "He will attack enemies. (and take damage from them)",
          alignment_enum: 1, vertical_alignment_enum: 0,
          text_offset_x: 56, text_offset_y: 0,
          x: @world.barbarian.position.x, y: @world.barbarian.position.y, w: @world.barbarian.sprite.w, h: @world.barbarian.sprite.h
        },
        7 => { text: "Keep his health up: if it falls to zero the battle is lost!",
          alignment_enum: 1, vertical_alignment_enum: 0,
          text_offset_x: 68, text_offset_y: 0,
          x: @world.barbarian.position.x, y: @world.barbarian.position.y, w: @world.barbarian.sprite.w, h: @world.barbarian.sprite.h
        },
        8 => { text: "Click on him to cast Healing Touch. (Make sure the cursor is over him!)",
          alignment_enum: 0, vertical_alignment_enum: 0,
          text_offset_x: -228, text_offset_y: 0,
          x: @world.barbarian.position.x, y: @world.barbarian.position.y, w: @world.barbarian.sprite.w, h: @world.barbarian.sprite.h
        },
        9 => { text: "You can cast faster if you also use the keyboard. (The #1 key -- Make sure the cursor is over him!)",
          alignment_enum: 0, vertical_alignment_enum: 0,
          text_offset_x: -224, text_offset_y: 0,
          x: @world.barbarian.position.x, y: @world.barbarian.position.y, w: @world.barbarian.sprite.w, h: @world.barbarian.sprite.h
        },
        10 => { text: "These are enemies.",
          alignment_enum: 1, vertical_alignment_enum: 0,
          text_offset_x: 0, text_offset_y: 0,
          x: 780, y: 144, w: 416, h: 200
        },
        11 => { text: "More will arrive as the battle progresses.",
          alignment_enum: 1, vertical_alignment_enum: 0,
          text_offset_x: 0, text_offset_y: 0,
          x: 780, y: 144, w: 416, h: 200
        },
        12 => { text: "This is the event timeline. It shows you enemy reinforcements and other events.",
          alignment_enum: 1, vertical_alignment_enum: 0,
          text_offset_x: 0, text_offset_y: -48,
          x: 48, y: 656, w: args.grid.w - 48 * 2, h: 24
        },
        13 => { text: "Prepare yourself, healer! They upon us!",
          alignment_enum: 1, vertical_alignment_enum: 0,
          text_offset_x: 0, text_offset_y: -48,
          x: args.grid.w.half, y: args.grid.h.half, w: 0, h: 0
        },
      }
    elsif @world.level.level_progress.tutorial_id == :stun_unlocked
      hints = {
        1 => {
          text: "You have unlocked Stun.",
          alignment_enum: 1, vertical_alignment_enum: 0,
          text_offset_x: 8, text_offset_y: 0,
          x: 160, y: 0, w: 80, h: 96
        },
        2 => {
          text: "This spell will interrupt all of your opponents. Use it to block incoming attacks!",
          alignment_enum: 0, vertical_alignment_enum: 0,
          text_offset_x: -192, text_offset_y: 0,
          x: 160, y: 0, w: 80, h: 96
        },
        3 => { text: "A new weapon in our arsenal: prepare yourself, healer! They upon us!",
          alignment_enum: 1, vertical_alignment_enum: 0,
          text_offset_x: 0, text_offset_y: -48,
          x: args.grid.w.half, y: args.grid.h.half, w: 0, h: 0
        }, #160
      }
    elsif @world.level.level_progress.tutorial_id == :cure_unlocked
      hints = {
        1 => {
          text: "You have unlocked Cure.",
          alignment_enum: 1, vertical_alignment_enum: 0,
          text_offset_x: 0, text_offset_y: 0,
          x: 232, y: 0, w: 80, h: 96
        },
        2 => {
          text: "This spell will completely restore your defender's health. Use it when the situation is dire!",
          alignment_enum: 0, vertical_alignment_enum: 0,
          text_offset_x: -264, text_offset_y: 0,
          x: 232, y: 0, w: 80, h: 96
        },
        3 => { text: "A new power at our disposal. Healer: they are again upon us!",
          alignment_enum: 1, vertical_alignment_enum: 0,
          text_offset_x: 0, text_offset_y: -48,
          x: args.grid.w.half, y: args.grid.h.half, w: 0, h: 0
        }, #232
      }
    elsif @world.level.level_progress.tutorial_id == :smite_unlocked
      hints = {
        1 => {
          text: "You have unlocked Smite.",
          alignment_enum: 1, vertical_alignment_enum: 0,
          text_offset_x: 12, text_offset_y: 0,
          x: 88, y: 0, w: 80, h: 96
        },
        2 => {
          text: "This spell will damage an opponent. Use it whenever it is available to aid your party!",
          alignment_enum: 0, vertical_alignment_enum: 0,
          text_offset_x: -116, text_offset_y: 0,
          x: 88, y: 0, w: 80, h: 96
        },
        3 => {
          text: "(Use the keyboard for this ability. You don't have to target an enemy.)",
          alignment_enum: 0, vertical_alignment_enum: 0,
          text_offset_x: -112, text_offset_y: 0,
          x: 88, y: 0, w: 80, h: 96
        },
        4 => { text: "A fine weapon in our arsenal. Healer: they are here!",
          alignment_enum: 1, vertical_alignment_enum: 0,
          text_offset_x: 0, text_offset_y: -48,
          x: args.grid.w.half, y: args.grid.h.half, w: 0, h: 0
        }, #88
      }
    end

    if @@hint_id.nil?
      # system initialization
      @@hint_id = 1
      @@hint_at = args.tick_count
      args.sfx.play :tutorial_hint_1
    end

    # darken background
    args.outputs[:tutorial_back].w = args.grid.w
    args.outputs[:tutorial_back].h = args.grid.h
    args.outputs[:tutorial_back].primitives << {
      x: 0,
      y: 0,
      w: args.grid.w,
      h: args.grid.h,
      a: 192,
    }.solid!

    hint = hints[@@hint_id]
    unless hint.nil?
      # highlight hint area
      args.outputs[:tutorial_back].primitives << {
        x: hint.x,
        y: hint.y,
        w: hint.w,
        h: hint.h,
        r: 255,
        g: 255,
        b: 255,
        a: 255 * @@hint_at.ease(25),
      }.solid!

      # render hint mask
      args.outputs.primitives << {
        x: 0,
        y: 0,
        w: args.grid.w,
        h: args.grid.h,
        path: :tutorial_back,
        blendmode_enum: 3
      }.sprite!

      # render text
      args.outputs.primitives << {
        x: hint.x + hint.w.half + hint.text_offset_x,
        y: hint.y + hint.h + hint.text_offset_y,
        text: hint.text,
        size_enum: 0,
        alignment_enum: hint.alignment_enum,
        vertical_alignment_enum: hint.vertical_alignment_enum,
        font: $font_body,
        r: 255,
        g: 255,
        b: 255,
        a: 255 * @@hint_at.ease(25),
      }.label!
    end

    if args.inputs.keyboard.key_up.enter || args.inputs.keyboard.key_up.space # || args.inputs.mouse.click
      @@hint_id += 1
      @@hint_at = args.tick_count
      args.sfx.play :tutorial_hint_1
    end

    if args.inputs.mouse.click
      mouse = args.inputs.mouse
      e = @world.barbarian
      if mouse.inside_rect? e.rect
        unless e.health.dead?
          # spell
          w = e.sprite.w * 1.5
          h = e.sprite.h * 1.5
          @world.entities << SpellEffectEntity.new(
            position: { x: mouse.x - w.half, y: mouse.y - h.half },
            sprite: { w: w, h: h }
          )
          args.sfx.play(:spell_heal_1)
        end
      end
    end

    if hint.nil?
      @@hint_id = nil
      @world.transition_to_level(args)
    end
  end
end