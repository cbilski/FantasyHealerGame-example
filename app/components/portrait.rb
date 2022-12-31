class Portrait < Draco::Component
  attribute :path, default: ''
  attribute :tile_x, default: 0
  attribute :tile_y, default: 0
  attribute :tile_w, default: 32
  attribute :tile_h, default: 32
end