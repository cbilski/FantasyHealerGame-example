class LevelProgress < Draco::Component
  attribute :state, default: :in_progress

  attribute :started_at, default: 0
  attribute :ends_at, default: 0
  attribute :ended_at, default: 0
  attribute :events, default: [] # :events_template is duped into events at level start

  attribute :events_template, default: [
    { at:  10.seconds, event_id: :spawn_skeleton, health:  4.0, attack_power: 1.5 },
    { at:  17.seconds, event_id: :spawn_skeleton, health:  4.0, attack_power: 1.5 },

    { at:  24.seconds, event_id: :spawn_skeleton, health:  5.0, attack_power: 2.5, scale: 1.25, r: 255, g: 192, b: 128 },
    { at:  30.seconds, event_id: :spawn_skeleton, health:  7.5, attack_power: 2.5, scale: 1.25, r: 255, g: 192, b: 128 },
    { at:  36.seconds, event_id: :spawn_skeleton, health:  7.5, attack_power: 2.5, scale: 1.25, r: 255, g: 192, b: 128 },

    { at:  40.seconds, event_id: :spawn_skeleton, health: 10.0, attack_power: 4.0, scale: 1.25, r: 128, g: 192, b: 255 },
    { at:  44.seconds, event_id: :spawn_skeleton, health: 12.5, attack_power: 4.0, scale: 1.25, r: 128, g: 192, b: 255 },
    { at:  49.seconds, event_id: :spawn_skeleton, health: 15.0, attack_power: 4.0, scale: 1.25, r: 128, g: 192, b: 255 },

    { at:  60.seconds, event_id: :spawn_skeleton, health: 20.0, attack_power: 5.0 },
    { at:  61.seconds, event_id: :spawn_skeleton, health: 20.0, attack_power: 5.0 },

    { at:  76.seconds, event_id: :spawn_skeleton, health: 30.0, attack_power: 7.5 },
    { at:  77.seconds, event_id: :spawn_skeleton, health: 30.0, attack_power: 7.5 },
    { at:  78.seconds, event_id: :spawn_skeleton, health: 30.0, attack_power: 7.5 },

    { at:  95.seconds, event_id: :spawn_skeleton, health: 60.0, attack_power: 1.0, scale: 1.25, r: 128, g: 192, b: 255 },
    { at:  96.seconds, event_id: :spawn_skeleton, health:  5.0, attack_power: 7.5 },
    { at:  97.seconds, event_id: :spawn_skeleton, health:  5.0, attack_power: 7.5 },
    { at:  98.seconds, event_id: :spawn_skeleton, health:  5.0, attack_power: 7.5 },

    { at: 120.seconds, event_id: :spawn_skeleton, health: 90.0, attack_power: 10.0, scale: 2.00, r: 128, g: 192, b: 255 },
  ]

  attribute :tutorial_id, default: :introduction
  attribute :tutorial_flag, default: false
end