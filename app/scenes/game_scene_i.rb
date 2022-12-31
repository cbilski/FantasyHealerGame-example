class GameScene1 < Draco::World
  attr_reader :id

  entity UiActionButtonEntity, # Healing Touch
    as: :spell1, #button1
    button:   { selected: false, enabled: true, key: 1 },
    position: { x: 24, y: 24 },
    sprite:   { w: 64, h: 64, tile_x: 0, tile_y: 64, tile_w: 32, tile_h: 32, path: 'sprites/icons/7soul.itch.io/skills.png', path_disabled: 'sprites/icons/7soul.itch.io/skills-gray.png'}

  entity UiActionButtonEntity, # Smite
    as: :spell2, #button4
    button:   { selected: false, enabled: false, key: 2 },
    position: { x: 96, y: 24 },
    sprite:   { w: 64, h: 64, tile_x: 64, tile_y: 224, tile_w: 32, tile_h: 32, path: 'sprites/icons/7soul.itch.io/skills.png', path_disabled: 'sprites/icons/7soul.itch.io/skills-gray.png'}

  entity UiActionButtonEntity, # Stun
    as: :spell3, #button2
    button:   { selected: false, enabled: false, key: 3 },
    position: { x: 168, y: 24 },
    sprite:   { w: 64, h: 64, tile_x: 320, tile_y: 256, tile_w: 32, tile_h: 32, path: 'sprites/icons/7soul.itch.io/skills.png', path_disabled: 'sprites/icons/7soul.itch.io/skills-gray.png', angle: -90 }

  entity UiActionButtonEntity, # Cure
    as: :spell4, #button3
    button:   { selected: false, enabled: false, key: 4 },
    position: { x: 240, y: 24 },
    sprite:   { w: 64, h: 64, tile_x: 64, tile_y: 64, tile_w: 32, tile_h: 32, path: 'sprites/icons/7soul.itch.io/skills.png', path_disabled: 'sprites/icons/7soul.itch.io/skills-gray.png'}

  entity HeroEntity,
    as: :barbarian,
    position: { x: 160 },
    sprite: { type: :barbarian }

  entity HealerEntity,
    as: :healer

  entity LevelEntity,
    as: :level,
    level_progress: { state: :in_progress }

  entity EnemyEntity,
    position: { x: 768 },
    sprite: { type: :skeleton, state: :idle_1, w: 192 * 1.25, h: 192 * 1.25, frame: 3 }

  entity EnemyEntity,
    position: { x: 960 },
    sprite: { type: :skeleton, state: :idle_1, w: 192 * 1.25, h: 192 * 1.25 }

  entity DialogueEntity,
    dialogue: { id: :dialog_text_1 }

  entity CalendarEntity,
    as: :calendar

  def initialize(id)
    super()
    @id = id

    # always-on systems
    systems << RenderBackgroundSystem
    systems << RenderEnemySpritesSystem
    systems << RenderHeroSpritesSystem
    systems << RenderSpellEffectsSystem
    systems << RenderUiSystem
    systems << RenderTextSystem
    systems << RenderDebugSystem

    # conditional systems
    if $flags.no_intro
      systems << LevelSetupSystem
    else
      systems << DialogueGameloopSystem
    end
  end

  def scene_activate(args)

  end

  def scene_deactivate(args)

  end

  # called by LevelGameloopSystem when no more events remain and all enemies are dead
  def transition_to_win(args)
    args.sfx.loop_fade_out(:combat_1, 1.seconds)
    args.sfx.play!(:cinematic_hit_1)
    args.sfx.play!(:victory_music_1)

    # remove user input system (cleanup everything so we can start over)
    systems.delete(LevelEnemyAiSystem)
    systems.delete(LevelHeroAiSystem)
    systems.delete(LevelUserInputSystem)
    systems.delete(LevelGameloopSystem)

    # add new system
    systems << WinGameloopSystem
  end

  # called by DialogueGameloopSystem on Day 0
  def transition_to_tutorial(args)
    level.level_progress.tutorial_flag = false

    if $flags.no_tutorial
      transition_to_level(args)
    else
      systems << TutorialGameloopSystem
    end
  end

  # typically invoked from DeathGameloopSystem
  def transition_to_boon(args)
    BoonGameloopSystem.setup(args, self)
    systems.delete(DeathGameloopSystem)
    systems.delete(WinGameloopSystem)

    # add new system
    systems << BoonGameloopSystem
  end

  # called by LevelGameloopSystem when we have noone to heal
  def transition_to_death(args)
    args.sfx.loop_fade_out(:combat_1, 2.seconds)
    args.sfx.loop_fade_in(:dead_1, 4.seconds)
    args.sfx.play(:cinematic_hit_1)

    # remove user input system (cleanup everything so we can start over)
    systems.delete(LevelEnemyAiSystem)
    systems.delete(LevelHeroAiSystem)
    systems.delete(LevelUserInputSystem)
    systems.delete(LevelGameloopSystem)

    if @calendar.day.day_num < 2
      systems << DeathGameloopSystem # Show the "you're dead"
    elsif @calendar.day.day_num == 2
      transition_to_boon(args)
      spell2.button.enabled = true
      level.level_progress.tutorial_flag = true
      level.level_progress.tutorial_id = :smite_unlocked
    elsif @calendar.day.day_num == 4
      transition_to_boon(args)
      spell3.button.enabled = true
      level.level_progress.tutorial_flag = true
      level.level_progress.tutorial_id = :stun_unlocked
    elsif @calendar.day.day_num == 6
      transition_to_boon(args)
      spell4.button.enabled = true
      level.level_progress.tutorial_flag = true
      level.level_progress.tutorial_id = :cure_unlocked
    else
      transition_to_boon(args)
    end
  end

  # called by this class (to skip stuff), BoonGameloopSystem, TutorialGameloopSystem
  def transition_to_level(args)
    # the transition_to_ methods are a giant mess: need to be reworked
    # remove user input system (cleanup everything so we can start over)
    systems.delete(WinGameloopSystem)
    systems.delete(TutorialGameloopSystem)
    systems.delete(BoonGameloopSystem)
    BoonGameloopSystem.cleanup(args, self)

    # special case if a new tutorial is ready
    if level.level_progress.tutorial_flag == true
      transition_to_tutorial(args)
      return # OMG this needs to be reworked: what a mess...
    end

    args.sfx.stop!(:victory_music_1)

    # check for dialog on this day
    dialog_id = "dialog_day_#{@calendar.day.day_num}".to_sym
    dialog = CharacterDialog.create_dialog(dialog_id)
    if dialog.length > 0
      entities[Dialogue].each { |e| entities.delete(e) } # sanity check to remove static one which can be skipped

      log "[transition_to_level] dialog init."
      args.sfx.play!(:cinematic_hit_1)

      entities << DialogueEntity.new({ dialogue: { id: dialog_id } })
      systems << DialogueGameloopSystem
    else
      args.sfx.play!(:cinematic_hit_1)
      systems << LevelSetupSystem
    end
  end

  def tick(args)
    super # do draco things
  end

  def reset
    barbarian.reset

    entities[Enemy].each { |en| entities.delete(en) }

    entities[Hero].each { |he|
      he.sprite.state = :idle_1
      he.health.reset
    }

    entities << EnemyEntity.new(
      position: { x: 768 },
      sprite: { type: :skeleton, state: :idle_1, w: 192 * 1.25, h: 192 * 1.25, frame: 3 }
    )

    entities << EnemyEntity.new(
      position: { x: 960 },
      sprite: { type: :skeleton, state: :idle_1, w: 192 * 1.25, h: 192 * 1.25 }
    )

    spell2.button.cooldown = 0
    spell3.button.cooldown = 0
    spell4.button.cooldown = 0
  end
end