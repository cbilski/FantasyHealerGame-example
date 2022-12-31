class EnemyAi < Draco::Component
  attribute :state, default: :unknown
  attribute :state_change_at, default: 0
end