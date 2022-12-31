class Button < Draco::Component
  attribute :selected, default: false
  attribute :enabled, default: false

  attribute :key, default: 1
  attribute :spell, default: :unknown
  attribute :cooldown, default: 0
end