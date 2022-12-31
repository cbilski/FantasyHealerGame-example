class HealerEntity < Draco::Entity
  component Position, x: 64, y: 128
  component Sprite, type: :healer, state: :idle_1, w: 160, h: 160

  # component Tag(:player_avatar) # ==> "component PlayerAvatar"
  # component Tag(:hero)          # ==> "component Hero"
  # component Tag(:heal_target)   # ==> "component HealTarget"
  # component Tag(:click_target)  # ==> "component ClickTarget"
  # component Health, value: 10, max_value: 10

  attr_accessor :temp
  def initialize(args = {})
    super
    @temp = {}
  end

  def reset
    health.reset
    sprite.state = :idle_1
  end
end