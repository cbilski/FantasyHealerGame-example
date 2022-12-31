class Health < Draco::Component
  attribute :value, default: 1
  attribute :max_value, default: 1
  attribute :upgrade_tier, default: 0
  attribute :upgrade_track, default: {
    0 => { value:  5.0 },
    1 => { value:  6.6 },
    2 => { value:  9.8 },
    3 => { value: 16.2 },
    4 => { value: 29.0 },
    5 => { value: 54.6 },
  }
  attribute :upgrade_bonus, default: {
    0 => { value:  0.0 },
    1 => { value:  1.6 },
    2 => { value:  3.2 },
    3 => { value:  6.4 },
    4 => { value: 12.8 },
    5 => { value: 25.6 },
  }

  def alive?
    @value > 0
  end

  def dead?
    @value <= 0
  end

  def add amount
    @value = (@value + amount).clamp(0, @max_value).round(2)
  end

  def reset
    @value = @max_value
  end

  def maxxed?
    @upgrade_tier >= (@upgrade_track.length - 1)
  end
end