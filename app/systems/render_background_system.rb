class RenderBackgroundSystem < Draco::System

  def tick(args)

    # background color
    args.outputs.background_color = [64, 64, 64]

    num_tiles = 2
    zoom_back = 2.5

    x_offset = 0
    i = 0
    while i < num_tiles
      # background
      # args.outputs.primitives << {
      #   x: x_offset,
      #   y: 128,
      #   w: 384 * zoom_back,
      #   h: 320 * zoom_back,
      #   path: '/sprites/backgrounds/clembod.itch.io/Back_Forest_1.png'
      # }.sprite!

      # background
      args.outputs.primitives << {
        x: x_offset,
        y: 128,
        w: 384 * zoom_back,
        h: 320 * zoom_back,
        path: '/sprites/backgrounds/clembod.itch.io/Back_tree_1.png'
      }.sprite!

      # background
      args.outputs.primitives << {
        x: x_offset,
        y: 128,
        w: 384 * zoom_back,
        h: 320 * zoom_back,
        path: '/sprites/backgrounds/clembod.itch.io/Back_tree_2.png'
      }.sprite!

      x_offset += 384 * zoom_back
      i += 1
    end

    # quick-and-dirty tiles
    i = 0
    while i < 20
      args.outputs.primitives << {
        x: 64 * i,
        y: 96,
        w: 64,
        h: 64,
        tile_x: 160,
        tile_y: 80,
        tile_w: 16,
        tile_h: 16,
        path: '/sprites/tiles/clembod.itch.io/country_village_tileset.png'
      }.sprite!

      i += 1
    end
  end

end