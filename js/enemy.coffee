
define(['./creature'], (Creature) ->

  class Enemy extends Creature

    constructor: (pos, size, io) ->
      rect = new iio.Rect(pos, size).enableKinematics()
      rect.setFillStyle( '#ee0000' )

      super( rect, 1, io )

      rect.vel.x = @speed
      rect.vel.y = @speed

      @rect.bounds.right.callback = (obj) ->
        obj.vel.x = - obj.vel.x

      @goal = new iio.Vec(0,0)

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
    move_towards: ->

      cur_pos = @rect.pos
      dir = @compare(cur_pos.x, @goal.x)

      @rect.vel.x = dir * @speed
      dir = @compare(cur_pos.y, @goal.y)

      @rect.vel.y = dir * @speed

      max_speed = 3
      @speed = cur_pos.distance(@goal) / (max_speed * 2)
      if @speed > max_speed
        @speed = max_speed

    update: (dest)->

      @move_towards(dest)

      @rect.update()

)
