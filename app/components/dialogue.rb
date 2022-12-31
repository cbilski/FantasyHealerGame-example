class Dialogue < Draco::Component
  attribute :id, default: :unknown
  attribute :status, default: :not_started
  attribute :widget, default: :unknown
end