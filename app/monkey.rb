module Draco
  # monkey-patch Entity to make a rect accessor
  class Entity
    def rect
      {
        x: position.x,
        y: position.y,
        w: sprite.w,
        h: sprite.h,
      }
    end
  end
end

class Numeric
  def trim
    i, f = self.to_i, self.to_f
    i == f ? i : f
  end
end