class Text < Draco::Component
  attribute :value, default: 25
  attribute :delete_at, default: 0

  attribute :r, default: 255
  attribute :g, default: 255
  attribute :b, default: 255
end