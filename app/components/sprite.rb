class Sprite < Draco::Component
  # This component has likely grown to do too much and should be reworked...
  attribute :type, default: :unknown
  attribute :last_state, default: :idle
  attribute :state, default: :idle
  attribute :frame, default: 0
  attribute :zoom, default: 1
  attribute :angle, default: 0
  attribute :alpha, default: 255
  attribute :r, default: 255
  attribute :g, default: 255
  attribute :b, default: 255
  attribute :scale, default: 1.0

  attribute :w, default: 32
  attribute :h, default: 32
  attribute :path, default: ''
  attribute :path_disabled, default: ''
  attribute :tile_x, default: 0
  attribute :tile_y, default: 0
  attribute :tile_w, default: 32
  attribute :tile_h, default: 32

  attribute :shake_until, default: 0
  attribute :flash_at, default: 0
  attribute :flash_duration, default: 0
  attribute :fade_at, default: 0
  attribute :fade_duration, default: 90
end