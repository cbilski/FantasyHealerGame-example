class HealPower < Draco::Component
  attribute :value, default: 0.01
  attribute :upgrade_tier, default: 0
  attribute :upgrade_track, default: {
    0 => { value: 0.01 },
    1 => { value: 0.03 },
    2 => { value: 0.07 },
    3 => { value: 0.15 },
    4 => { value: 0.31 },
    5 => { value: 0.63 },
  }
  attribute :upgrade_bonus, default: {
    0 => { value:  0.0 },
    1 => { value:  0.2 },
    2 => { value:  0.4 },
    3 => { value:  0.8 },
    4 => { value:  1.6 },
    5 => { value:  3.2 },
  }

  def maxxed?
    @upgrade_tier >= (@upgrade_track.length - 1)
  end
end