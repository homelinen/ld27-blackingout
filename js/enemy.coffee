
define(['./creature'], (Creature) ->

  class Enemy extends Creature

    constructor: (io) ->
      rect = new iio.Rect(io.canvas.center, 32).enableKinematics()
      rect.setFillStyle( '#ee0000' )

      super( rect, 3, io )

      rect.vel.x = @speed
      rect.vel.y = @speed

      @rect.bounds.right.callback = (obj) ->
        obj.vel.x = - obj.vel.x

    # Compare two integers.
    #
    # Returns:
    #   1 for >
    #   -1 for <
    #   0 for =
    compare: (x, y) ->
      if x > y
        -1
      else if x < y
        1
      else
        0

    # Modify velocity to move towards target
    move_towards: (vec) ->

      cur_pos = @rect.pos
      dir = @compare(cur_pos.x, vec.x)

      @rect.vel.x = dir * @speed
      dir = @compare(cur_pos.y, vec.y)

      @rect.vel.y = dir * @speed

      max_speed = 3
      @speed = cur_pos.distance(vec) / (max_speed * 2)
      if @speed > max_speed
        @speed = max_speed

    update: (dest)->

      @move_towards(dest)

      @rect.update()

)
