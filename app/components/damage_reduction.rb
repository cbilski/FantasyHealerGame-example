class DamageReduction < Draco::Component
  attribute :value, default: 0.0
  attribute :upgrade_tier, default: 0
  attribute :upgrade_track, default: {
    0 => { value: 0.00 },
    1 => { value: 0.10 },
    2 => { value: 0.20 },
    3 => { value: 0.30 },
    4 => { value: 0.40 },
    5 => { value: 0.50 },
  }
  attribute :upgrade_bonus, default: {
    0 => { value:  0.0 },
    1 => { value:  0.1 },
    2 => { value:  0.1 },
    3 => { value:  0.1 },
    4 => { value:  0.1 },
    5 => { value:  0.1 },
  }

  def maxxed?
    @upgrade_tier >= (@upgrade_track.length - 1)
  end
end