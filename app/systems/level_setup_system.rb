#noinspection RubyNilAnalysis
class LevelSetupSystem < Draco::System

  def tick(args)
    # this system's job is to setup entities and systems for normal play, then remove itself
    #
    log "[SETUP] Level setup."

    @world.reset

    # increment the day count (so we can do interesting deja vu things)
    #
    @world.calendar.day.day_num += 1

    # set the level up
    #
    last_event = @world.level.level_progress.events_template[@world.level.level_progress.events_template.length - 1]

    @world.level.level_progress.state = :in_progress
    @world.level.level_progress.started_at = args.tick_count
    @world.level.level_progress.ends_at = args.tick_count + last_event.at
    @world.level.level_progress.events = []
    @world.level.level_progress.events_template.each { |e| @world.level.level_progress.events << e.dup }

    # get systems setup
    #
    @world.systems.delete(LevelSetupSystem)
    @world.systems << LevelUserInputSystem
    @world.systems << LevelEnemyAiSystem
    @world.systems << LevelHeroAiSystem
    @world.systems << LevelGameloopSystem

    # init music
    args.sfx.loop_fade_out(:dead_1, 1.seconds)
    args.sfx.loop(:combat_1) unless args.sfx.looping?(:combat_1)
  end

end