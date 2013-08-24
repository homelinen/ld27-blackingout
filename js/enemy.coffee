
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

    # Modify velocity to move towards target
    move_towards: (vec) ->

      cur_pos = @rect.pos

      if cur_pos.x > vec.x
        dir = -1
      else if cur_pos.x < vec.x
        dir = 1
      else
        dir = 0

      @rect.vel.x = dir * @speed

      if cur_pos.y > vec.y
        dir = -1
      else if cur_pos.y < vec.y
        dir = 1
      else
        dir = 0

      @rect.vel.y = dir * @speed

    update: (dest)->

      @move_towards(dest)

      @rect.update()

)
