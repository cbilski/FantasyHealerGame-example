class StunPower < Draco::Component
  attribute :value, default: 15
  attribute :upgrade_tier, default: 0
  attribute :upgrade_track, default: {
    0 => { value: 15 },
    1 => { value: 11 },
    2 => { value: 8 },
    3 => { value: 6 },
    4 => { value: 5 },
    5 => { value: 4 },
  }
  attribute :upgrade_bonus, default: {
    0 => { value:   0 },
    1 => { value:  -4 },
    2 => { value:  -3 },
    3 => { value:  -2 },
    4 => { value:  -1 },
    5 => { value:  -1 },
  }

  def maxxed?
    @upgrade_tier >= (@upgrade_track.length - 1)
  end
end