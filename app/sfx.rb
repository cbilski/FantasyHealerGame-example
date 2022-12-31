class Sfx
  attr_accessor :queued
  attr_accessor :loop_watcher

  attr_reader :music_mast
  attr_reader :sfx_mast

  def initialize(args)
    @args = args
    @music_mast = $flags.no_music ? 0.0 : 0.5
    @sfx_mast = $flags.no_sfx ? 0.0 : 0.5
    @loop_watcher = []

    @queued = []
    @last_played = -5
  end

  def music_mast=(level)
    @music_mast = level.clamp(0, 1.0)
    @args.audio.each do |key, value|
      if value.type == :music
        value.gain = @music_mast * value.vol
        value.changed_at = @args.tick_count # debugging only
      end
    end
  end

  def sfx_mast=(level)
    @sfx_mast = level.clamp(0, 1.0)
    @args.audio.each do |key, value|
      if value.type == :sfx
        value.gain = @sfx_mast * value.vol
        value.changed_at = @args.tick_count # debugging only
      end
    end
  end

  def stop(sound_id)
    pause(sound_id)
  end

  def stop!(sound_id)
    if @args.audio.key?(sound_id)
      @args.audio.delete(sound_id)
    end
  end

  def pause(sound_id)
    if @args.audio.key?(sound_id)
      @args.audio[sound_id][:paused] = true
    end
  end

  def resume(sound_id)
    if @args.audio.key?(sound_id)
      @args.audio[sound_id][:paused] = false
    end
  end

  def loop(sound_id, queue: true)
    if @args.audio.key?(sound_id)
      resume(sound_id)
    end

    sounds = {
      :dialogue_text_1 => { type: :sfx,   vol: 0.50,  pitch: 1.0, input: "sounds/dialogue/chrislsound.itch.io-textdialoguesfxpack/subTri_2b.wav" },
      :dead_1          => { type: :music, vol: 0.125, pitch: 1.0, input: "sounds/music/epicorchestralactionmusicpack/Loop 3.wav" },
      :combat_1        => { type: :music, vol: 0.35,  pitch: 1.0, input: "sounds/music/epicorchestralactionmusicpack/Loop 1.wav" },
    }

    if sounds.key?(sound_id)
      sound = sounds[sound_id]
      gain = (sound.type == :music ? @music_mast : @sfx_mast) * sound.vol
      sound_data = [sound_id, { input: sound.input, gain: gain, pitch: sound.pitch, looping: true, paused: false, vol: sound.vol, type: sound.type }]
    else
      raise "args.sfx.loop: Unknown loop #{sound_id}!"
    end

    if queue
      unless sound_data.nil?
        @queued << sound_data
      end
    else
      @args.audio[sound_data[0]] = sound_data[1]
    end
  end

  def looping?(sound_id)
    result = false

    if @args.audio.key?(sound_id)
      result = @args.audio[sound_id].looping == true
    end

    result
  end

  def playing?(sound_id)
    result = false

    if @args.audio.key?(sound_id)
      result = true
    end

    result
  end

  def looping_now?
    result = :no_loop
    # issue: only returns one looper (need to rework with tag to find :music vs. :stinger, :ambient, etc.)
    @args.audio.each do |sound_id, sound_data|
      if sound_data.looping == true
        result = sound_id
        break
      end
    end

    result
  end

  def loop_to(sound_id1, sound_id2)
    @loop_watcher << [sound_id1, sound_id2] # change to sound_id2 after sound_id1 is gone
  end

  def play!(sound_id, gain_modifier = nil)
    sounds = {
          :victory_music_1 => { type: :music, vol: 0.35, pitch: 1.0, input: 'sounds/music/rpgorchestralessentialsreborn/REBORN - Training is Over MP3.mp3' },
          :cinematic_hit_1 => { type:   :sfx, vol: 1.00, pitch: 1.0, input: 'sounds/cinematic/Epic Movie Trailer Impact Drum Organic Slam Hit 1 Wood Heavy.wav' },
            :enemy_death_1 => { type:   :sfx, vol: 1.00, pitch: 1.0, input: 'sounds/combat-death/Ancient_Game_Monster_Voice_Death_1_Grunt.wav' },
            :spell_smite_1 => { type:   :sfx, vol: 1.00, pitch: 1.0, input: 'sounds/spells/Ancient_Game_Magic_Spell_Cast_Hit_1.wav' },
             :spell_stun_1 => { type:   :sfx, vol: 1.00, pitch: 1.0, input: 'sounds/spells/Ancient_Game_Powerful_Instant_Buff_Spell_1.wav' },
          :tutorial_hint_1 => { type:   :sfx, vol: 0.50, pitch: 0.7, input: 'sounds/tutorial/Ancient_Game_Fantasy_Bell_UI_Touch_1.wav' },
      :splash_transition_1 => { type:   :sfx, vol: 0.50, pitch: 1.0, input: 'sounds/transitions/War_UI_MenuFuturistic_Menu_Rounded_Transition_1.wav' },
      :splash_transition_2 => { type:   :sfx, vol: 0.50, pitch: 1.0, input: 'sounds/transitions/War_UI_MenuFuturistic_Menu_Rounded_Transition_2.wav' },
    }

    sfx_mast = @sfx_mast
    sfx_mast *= gain_modifier unless gain_modifier.nil?

    if sounds.key?(sound_id)
      sound = sounds[sound_id]
      gain = (sound.type == :music ? @music_mast : sfx_mast) * sound.vol
      sound_data = [sound_id, { input: sound.input, gain: gain, pitch: sound.pitch, looping: false, paused: false, vol: sound.vol }]
    else
      # special case logic (randomize SFX, etc.)
      #
      case sound_id
      when :hurt_male_1
        @hurt_male_1_index ||= 0
        @hurt_male_1_max ||= 3 # sound channels
        @hurt_male_1_index = (@hurt_male_1_index + 1) % @hurt_male_1_max
        sfx_sym = ("hurt_male_1_" + @spell_heal_index.to_s).to_sym
        wav_vol = 0.5
        rand_id = rand(5)
        path = "sounds/combat-hurt/fighter_1_hurt_1#{rand_id}.wav"
        sound_data = [sfx_sym, { input: path, gain: sfx_mast * wav_vol, pitch: 1.0, looping: false, paused: false }]
      when :combat_spawn_1
        @combat_spawn_1_index ||= 0
        @combat_spawn_1_max ||= 3 # sound channels
        @combat_spawn_1_index = (@combat_spawn_1_index + 1) % @combat_spawn_1_max
        sfx_sym = ("combat_spawn_1_" + @spell_heal_index.to_s).to_sym
        wav_vol = 1.0
        rand_id = rand(2) + 1
        path = "sounds/combat-spawn/Ancient_Game_Dark_Fantasty_Buff_#{rand_id}.wav"
        sound_data = [sfx_sym, { input: path, gain: sfx_mast * wav_vol, pitch: 1.0, looping: false, paused: false }]
      when :sword_attack_1
        @sword_attack_index ||= 0
        @sword_attack_max ||= 3 # sound channels
        @sword_attack_index = (@sword_attack_index + 1) % @sword_attack_max
        sfx_sym = ("sword_attack_" + @spell_heal_index.to_s).to_sym
        wav_vol = 1.0
        rand_id = rand(4) + 1
        path = "sounds/weapons/Ancient_Game_Sword_Weapon_Swing_Ring_#{rand_id}.wav"
        sound_data = [sfx_sym, { input: path, gain: sfx_mast * wav_vol, pitch: 1.0, looping: false, paused: false }]
      when :spell_heal_1
        @spell_heal_index ||= 0
        @spell_heal_max ||= 3 # sound channels
        @spell_heal_index = (@spell_heal_index + 1) % @spell_heal_max
        wav_vol = 1.0
        sfx_sym = ("spell_hea_" + @spell_heal_index.to_s).to_sym
        path = (rand(2) > 0) ? 'Ancient_Game_Heal_Character_3_Magic_Spell.wav' : 'Ancient_Game_Heal_Character_4_Electric_Magic_Spell.wav'
        path = 'sounds/spells/' + path
        sound_data = [sfx_sym, { input: path, gain: sfx_mast * wav_vol, pitch: 1.0, looping: false, paused: false }]
      when :weapon_impact_1
        @weapon_impact_1_index ||= 0
        @weapon_impact_1_max ||= 3 # sound channels
        @weapon_impact_1_index = (@weapon_impact_1_index + 1) % @weapon_impact_1_max
        sfx_sym = ("weapon_impact_1_" + @spell_heal_index.to_s).to_sym
        wav_vol = 0.5
        rand_id = rand(5) + 1
        path = "sounds/combat-impact/bullet_impact_body_thump_0#{rand_id}.wav"
        sound_data = [sfx_sym, { input: path, gain: sfx_mast * wav_vol, pitch: 1.0, looping: false, paused: false }]
      else
        raise "args.sfx.play: Unknown sound #{sound_id}!"
      end
    end

    if sound_data != nil
      @queued << sound_data
    end
  end

  def play(sound_id, gain_modifier = nil)
    return unless @queued.length < 5

    play!(sound_id, gain_modifier)
  end

  def play_proximity!(sound_id, distance)
    gain_mod = 1.0
    max_distance = 320.0
    far_distance = 16.0
    if distance > far_distance
      level_mod = max_distance - distance # 480 - value above 160
      gain_mod = level_mod / max_distance
      gain_mod = gain_mod ** 2
      #log "[SFX] #{sound_id} (#{level_mod}, #{gain_mod})"
    end
    play!(sound_id, gain_mod) if distance < max_distance
  end

  def play_proximity(sound_id, distance)
    gain_mod = 1.0
    max_distance = 320.0
    far_distance = 16.0
    if distance > far_distance
      level_mod = max_distance - distance # 480 - value above 160
      gain_mod = level_mod / max_distance
      gain_mod = gain_mod ** 2
      #log "[SFX] #{sound_id} (#{level_mod}, #{gain_mod})"
    end
    play(sound_id, gain_mod) if distance < max_distance
  end

  def loop_fade_in(sound_id, duration)
    loop(sound_id, queue: false)
    args = @args
    item = args.audio[sound_id]
    item.effect_type = :fade_in
    item.fade_in_at = args.tick_count
    item.fade_in_duration = duration
    item.fade_in_end = args.tick_count + duration
    item.fade_in_gain = item.gain
    @num_effects += 1
  end

  def loop_fade_out(sound_id, duration)
    args = @args
    if args.audio.key?(sound_id)
      item = args.audio[sound_id]
      item.effect_type = :fade_out
      item.fade_out_at = args.tick_count
      item.fade_out_duration = duration
      item.fade_out_end = args.tick_count + duration
      item.fade_out_gain = item.gain
      @num_effects += 1
    end
  end

  def tick(args)
    @args = args
    @num_effects ||= 0

    if @queued.length > 0 && args.tick_count.zmod?(4)
      sound_data = @queued[0]
      @queued.delete_at(0)
      args.audio[sound_data[0]] = sound_data[1]
    end

    if @loop_watcher.length > 0
      music_data = @loop_watcher[0]
      if args.audio.key?(music_data[0]) == false
        loop(music_data[1], queue: false)
        @loop_watcher.delete_at(0)
      else
        @args.audio[music_data[0]][:looping] = false # stop looping sound_id1
      end
    end

    if @num_effects > 0
      args.audio.each do |id,item|
        unless item.effect_type.nil?
          if item.effect_type == :fade_out
            item.gain = (1 - item.fade_out_at.ease(item.fade_out_duration)) * item.fade_out_gain
            if item.fade_out_end < args.tick_count
              stop!(id)
              @num_effects -= 1
              log "[SFX] #{id} has faded out."
            end
          elsif item.effect_type == :fade_in
            item.gain = item.fade_in_at.ease(item.fade_in_duration) * item.fade_in_gain
            if item.fade_in_end < args.tick_count
              item.delete(:effect_type)
              @num_effects -= 1
              log "[SFX] #{id} has faded in."
            end
          end
        end
      end
    end

    if $gtk.production == false
      #args.state.audio = args.audio if args.tick_count.zmod?(10)
      #args.state.sfx_mast = @sfx_mast if args.tick_count.zmod?(10)
      #args.state.music_mast = @music_mast if args.tick_count.zmod?(10)
    end
  end

  def serialize
    {
      music_mast: @music_mast,
      sfx_mast: @sfx_mast,
      queue_size: @queued.length
    }
  end

  def inspect
    serialize.to_s
  end

  def to_s
    serialize.to_s
  end
end
