class LevelEntity < Draco::Entity
  component LevelProgress, state: :in_progress
  component HealPower, value: 0.01

  component CurePower
  component StunPower
  component SmitePower

  def initialize(args = {})
    super
  end
end