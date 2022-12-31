#noinspection RubyNilAnalysis
class BoonGameloopSystem < Draco::System

  def tick(args)
    # dim background
    args.outputs.primitives << {
      x: 0,
      y: 0,
      w: args.grid.w,
      h: args.grid.h,
      a: 192,
    }.solid!

    # render boons
    @world.entities[Boon].each do |e|
      args.outputs.primitives << {
        x: e.position.x,
        y: e.position.y,
        w: e.sprite.w,
        h: e.sprite.h,
        r: 128,
        g: 128,
        b: e.button.selected ? 255 : 128
      }.solid!

      args.outputs.primitives << {
        x: e.position.x + e.sprite.w / 2,
        y: e.position.y + e.sprite.h - 32,
        text: e.boon.title,
        size_enum: 0,
        alignment_enum: 1,
        vertical_alignment_enum: 0,
        font: $font_body,
        r: 255,
        g: 255,
        b: 255,
        a: 255,
      }.label!

      args.outputs.primitives << {
        x: e.position.x + e.sprite.w.half + 4,
        y: e.position.y + e.sprite.h.half - 6,
        text: e.boon.boon_tier,
        size_enum: 12,
        alignment_enum: 1,
        vertical_alignment_enum: 1,
        font: $font_title,
        r: 255,
        g: 255,
        b: 255,
        a: 255,
      }.label!

      args.outputs.primitives << {
        x: e.position.x + e.sprite.w.half,
        y: e.position.y + 20,
        text: e.boon.boon_upgrade >= 0 ? "(+#{e.boon.boon_upgrade}#{e.boon.boon_label})" : "(#{e.boon.boon_upgrade}#{e.boon.boon_label})",
        size_enum: -2,
        alignment_enum: 1,
        vertical_alignment_enum: 1,
        font: $font_body,
        r: 255,
        g: 255,
        b: 255,
        a: 255,
      }.label!
    end

    # render text
    text = [
      "Healer, choose a boon",
      "(then ENTER or SPACE to continue)",
    ]

    y_base = args.grid.h.half + 100
    y_offset = 0

    text.each do |t|
      args.outputs.primitives << {
        x: args.grid.w.half,
        y: y_base - y_offset,
        text: t,
        size_enum: 0,
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

    # interact with boons and select them, if need be
    @world.entities[Boon].each do |e|
      if args.inputs.mouse.inside_rect?(e.rect)
        # select/deselect
        if args.inputs.mouse.click
          @world.entities[Boon].each { |b| b.button.selected = false }
          e.button.selected = true
        end

        # outline
        args.outputs.primitives << {
          x: e.position.x,
          y: e.position.y,
          w: e.sprite.w,
          h: e.sprite.h,
          b: 255
        }.border!

        # hover text
        args.outputs.primitives << {
          x: args.grid.w.half,
          y: e.position.y - 64,
          text: e.boon.description,
          size_enum: -3,
          font: $font_title,
          alignment_enum: 1,
          vertical_alignment_enum: 0,
          r: 255,
          g: 255,
          b: 255,
          a: 255,
        }.label!
      end
    end

    # keyboard input
    if args.inputs.keyboard.key_up.enter || args.inputs.keyboard.key_up.space # || args.inputs.mouse.click

      selected = nil
      @world.entities[Boon].each do |e|
        selected = e if e.button.selected
      end

      unless selected.nil?
        case selected.boon.boon_type
        when :attack_power
          @world.barbarian.attack_power.value = selected.boon.boon_value
          @world.barbarian.attack_power.upgrade_tier += 1
        when :damage_reduction
          @world.barbarian.damage_reduction.value = selected.boon.boon_value
          @world.barbarian.damage_reduction.upgrade_tier += 1
        when :health
          @world.barbarian.health.max_value = selected.boon.boon_value
          @world.barbarian.health.upgrade_tier += 1
        when :heal_power
          @world.level.heal_power.value = selected.boon.boon_value
          @world.level.heal_power.upgrade_tier += 1
        when :cure_power
          @world.level.cure_power.value = selected.boon.boon_value
          @world.level.cure_power.upgrade_tier += 1
        when :stun_power
          @world.level.stun_power.value = selected.boon.boon_value
          @world.level.stun_power.upgrade_tier += 1
        when :smite_power
          @world.level.smite_power.value = selected.boon.boon_value
          @world.level.smite_power.upgrade_tier += 1
        else
          # type code here
        end

        log "[BOON] #{selected.boon.character}.#{selected.boon.boon_type} is #{selected.boon.boon_value}."
        @world.transition_to_level(args)
      end
    end
  end

  def self.setup(args, world)

    next_health_tier = (world.barbarian.health.upgrade_tier + 1).clamp(0, world.barbarian.health.upgrade_track.length - 1)
    next_attack_tier = (world.barbarian.attack_power.upgrade_tier + 1).clamp(0, world.barbarian.attack_power.upgrade_track.length - 1)
    next_dmgred_tier = (world.barbarian.damage_reduction.upgrade_tier + 1).clamp(0, world.barbarian.damage_reduction.upgrade_track.length - 1)
    next_hpower_tier = (world.level.heal_power.upgrade_tier + 1).clamp(0, world.level.heal_power.upgrade_track.length - 1)
    next_cpower_tier = (world.level.cure_power.upgrade_tier + 1).clamp(0, world.level.cure_power.upgrade_track.length - 1)
    next_spower_tier = (world.level.stun_power.upgrade_tier + 1).clamp(0, world.level.stun_power.upgrade_track.length - 1)
    next_mpower_tier = (world.level.smite_power.upgrade_tier + 1).clamp(0, world.level.smite_power.upgrade_track.length - 1)

    # select boons
    #
    all_boons = [
      {
        title: 'Health',
        description: 'Grant your warrior with additional health. (Passive)',
        character: :barbarian,
        boon_type: :health,
        boon_tier: next_health_tier,
        boon_label: ' hp',
        boon_maxxed: world.barbarian.health.maxxed?,
        boon_value: world.barbarian.health.upgrade_track[next_health_tier].value,
        boon_upgrade: world.barbarian.health.upgrade_bonus[next_health_tier].value,
      },
      {
        title: 'Attack',
        description: 'Bless your warrior with righteous strength. (Passive)',
        character: :barbarian,
        boon_type: :attack_power,
        boon_tier: next_attack_tier,
        boon_label: ' dmg',
        boon_maxxed: world.barbarian.attack_power.maxxed?,
        boon_value: world.barbarian.attack_power.upgrade_track[next_attack_tier].value,
        boon_upgrade: world.barbarian.attack_power.upgrade_bonus[next_attack_tier].value,
      },
      {
        title: 'Defend',
        description: "Imbue your warrior with resiliency. (Passive damage reduction: #{world.barbarian.damage_reduction.upgrade_track[next_dmgred_tier].value * 100}%)",
        character: :barbarian,
        boon_type: :damage_reduction,
        boon_tier: next_dmgred_tier,
        boon_label: '%',
        boon_maxxed: world.barbarian.damage_reduction.maxxed?,
        boon_value: world.barbarian.damage_reduction.upgrade_track[next_dmgred_tier].value,
        boon_upgrade: world.barbarian.damage_reduction.upgrade_bonus[next_dmgred_tier].value,
      },
      {
        title: 'Heal Power',
        description: 'Increase the power of your healing touch.',
        character: :healer,
        boon_type: :heal_power,
        boon_tier: next_hpower_tier,
        boon_label: ' hp',
        boon_maxxed: world.level.heal_power.maxxed?,
        boon_value: world.level.heal_power.upgrade_track[next_hpower_tier].value,
        boon_upgrade: world.level.heal_power.upgrade_bonus[next_hpower_tier].value,
      }
    ]

    all_boons << {
      title: 'Smite Spell',
      description: 'Increase the damage of your smite spell.',
      character: :healer,
      boon_type: :smite_power,
      boon_tier: next_mpower_tier,
      boon_label: ' dmg',
      boon_maxxed: world.level.smite_power.maxxed?,
      boon_value: world.level.smite_power.upgrade_track[next_mpower_tier].value,
      boon_upgrade: world.level.smite_power.upgrade_bonus[next_mpower_tier].value,
    } if world.spell2.button.enabled

    all_boons << {
      title: 'Stun Spell',
      description: 'Decrease the cooldown of your stun spell.',
      character: :healer,
      boon_type: :stun_power,
      boon_tier: next_spower_tier,
      boon_label: ' sec',
      boon_maxxed: world.level.stun_power.maxxed?,
      boon_value: world.level.stun_power.upgrade_track[next_spower_tier].value,
      boon_upgrade: world.level.stun_power.upgrade_bonus[next_spower_tier].value,
    } if world.spell3.button.enabled

    all_boons << {
      title: 'Cure Spell',
      description: 'Decrease the cooldown of your cure spell.',
      character: :healer,
      boon_type: :cure_power,
      boon_tier: next_cpower_tier,
      boon_label: ' sec',
      boon_maxxed: world.level.cure_power.maxxed?,
      boon_value: world.level.cure_power.upgrade_track[next_cpower_tier].value,
      boon_upgrade: world.level.cure_power.upgrade_bonus[next_cpower_tier].value,
    } if world.spell4.button.enabled

    # filter maxxed boons
    maxxed_boons = all_boons.select { |b| b.boon_maxxed == true }
    all_boons = all_boons.select { |b| b.boon_maxxed == false }

    # setup ui params
    max_boons = 4 # default to 4
    max_boons = 3 if world.calendar.day.day_num == 1 # 3 on the first day
    max_boons = 5 if world.spell4.button.enabled # 5 after cure is unlocked

    button_w = 128
    button_h = 192
    button_y = args.grid.h.half - button_h
    button_x = args.grid.w / (max_boons + 1)

    i = 0
    x_offset = button_x
    while i < max_boons

      if all_boons.length > 0
        # select random boon
        boon_index = rand(all_boons.length)
        boon = all_boons[boon_index]
        all_boons.delete_at(boon_index)
      else
        # fill out list with maxxed boons (should be reworked)
        boon_index = rand(maxxed_boons.length)
        boon = maxxed_boons[boon_index]
        maxxed_boons.delete_at(boon_index)
      end

      world.entities << BoonEntity.new(
        position: { x: x_offset - button_w.half, y: button_y },
        sprite: { type: :unknown, state: :unknown, w: button_w, h: button_h },
        boon: boon
      )

      x_offset += button_x
      i += 1
    end
  end

  def self.cleanup(args, world)
    world.entities[Boon].each { |e| world.entities.delete(e) }
  end

end