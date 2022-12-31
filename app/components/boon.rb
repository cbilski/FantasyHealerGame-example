class Boon < Draco::Component
  attribute :title, default: 'Boon'
  attribute :description, default: 'Description'
  attribute :character, default: :unknown
  attribute :boon_type, default: :unknown
  attribute :boon_tier, default: :unknown
  attribute :boon_label, default: ''
  attribute :boon_value, default: 0
  attribute :boon_upgrade, default: 0
end