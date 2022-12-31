class SmitePower < Draco::Component
  attribute :value, default: 1.0
  attribute :upgrade_tier, default: 0
  attribute :upgrade_track, default: {
    0 => { value:  1.0 },
    1 => { value:  1.8 },
    2 => { value:  3.4 },
    3 => { value:  6.6 },
    4 => { value: 13.0 },
    5 => { value: 25.8 },
  }
  attribute :upgrade_bonus, default: {
    0 => { value:  0.0 },
    1 => { value:  0.8 },
    2 => { value:  1.6 },
    3 => { value:  3.2 },
    4 => { value:  6.4 },
    5 => { value: 12.8 },
  }

  def maxxed?
    @upgrade_tier >= (@upgrade_track.length - 1)
  end
end