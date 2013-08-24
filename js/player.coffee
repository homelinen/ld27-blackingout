
define(['./creature', './utility'], (Creature, Utility)->

  # Player class
  #
  # For storing state of the player and drawing them
  #
  # Fields:
  #   rect - The bounding box of the player
  #   vel - The current velocity of the player
  class Player extends Creature

    constructor: ( w, h, @grid_pos, io) ->
      rect = new iio.Rect(@grid_pos, w, h).enableKinematics()
      rect.setFillStyle( '#00ee00' )

      super(rect, 2, io)

    update: (map) ->
      # Check if movement will hit a wall
      cur_pos = @rect.pos.clone()
      cur_dir = @rect.vel

      next_pos = cur_pos.add(cur_dir)

      next_cell = map.getCellAt(next_pos)
      console.log map.cells[next_cell.x][next_cell.y].isPassable
      # Only update movement if not hitting a wall
      #
      # next_cell is false when there is no next cell, like when hitting border
      if map.cells[next_cell.x][next_cell.y].isPassable or next_cell == false
        #or cur_pos == next_pos

        @smooth_movement()

        @rect.update()
      else
        console.log("CRASH")
        @rect.vel = Utility.reverse(@rect.vel)

      return
)
