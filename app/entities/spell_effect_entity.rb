class SpellEffectEntity < Draco::Entity
  component Tag(:spell_effect)  # ==> "component SpellEffect"
  component Position, x: 0, y: 0
  component Sprite, type: :light_1, w: 48, h: 48
end