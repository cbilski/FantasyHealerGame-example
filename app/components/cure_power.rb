class CurePower < Draco::Component
  attribute :value, default: 25
  attribute :upgrade_tier, default: 0
  attribute :upgrade_track, default: {
    0 => { value: 25 },
    1 => { value: 23 },
    2 => { value: 20 },
    3 => { value: 16 },
    4 => { value: 11 },
    5 => { value:  5 },
  }
  attribute :upgrade_bonus, default: {
    0 => { value:   0 },
    1 => { value:  -2 },
    2 => { value:  -3 },
    3 => { value:  -4 },
    4 => { value:  -5 },
    5 => { value:  -6 },
  }

  def maxxed?
    @upgrade_tier >= (@upgrade_track.length - 1)
  end
end