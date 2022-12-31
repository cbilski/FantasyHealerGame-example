class BoonEntity < Draco::Entity
  component Tag(:click_target)  # ==> "component ClickTarget"
  component Position, x: 960, y: 128
  component Sprite, type: :skeleton, state: :idle_1, w: 320, h: 320
  component Boon, title: 'BoonEntity', description: 'BoonEntity'
  component Button, selected: false
end