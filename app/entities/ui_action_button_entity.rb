class UiActionButtonEntity < Draco::Entity
  component Tag(:click_target)     # ==> "component ClickTarget"
  component Tag(:ui_action_button) # ==> "component UiActionButton"
  component Position, x: 24, y: 24
  component Sprite, type: :action_button, w: 64, h: 64
  component Button, selected: false

  attr_accessor :temp
  def initialize(args = {})
    super
    @temp = {}
  end
end