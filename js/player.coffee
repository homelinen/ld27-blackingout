
define(['./utility'], (Utility)->

  # Player class
  #
  # For storing state of the player and drawing them
  #
  # Fields:
  #   rect - The bounding box of the player
  #   vel - The current velocity of the player
  class Player

    constructor: ( w, h, @grid_pos, io) ->
      @rect= new iio.Rect(@grid_pos, w, h).enableKinematics()
      @rect.setFillStyle( '#00ee00' )

      @rect.setVel(0,0)

      bound_options = [
         left =
           dir: 'left',
           x: 6,
           y: 0,
           constraint: 0 ,
         right =
           dir: 'right',
           x: -6,
           y: 0,
           constraint: io.canvas.width ,
         top =
           dir: 'top',
           x: 0,
           y: 6,
           constraint: 0 ,
         bottom =
           dir: 'bottom',
           x: 0,
           y: -6,
           constraint: io.canvas.height
      ]

      for bound in bound_options
        do (bound, @rect) ->
          @rect.setBound(bound.dir, bound.constraint, (obj) ->
            #FIXME: Magic number
            obj.vel.x = bound.x
            obj.vel.y = bound.y
            return true
          )

    move: (x, y)->
      @rect.vel.add(x,y)
      return

    # Update the logic attributes
    update: ->
      temp_vel = @rect.vel.clone()
      temp_vel = Utility.safe_normalize(temp_vel)

      @rect.vel.sub(temp_vel)
      @rect.vel.x = Math.round(@rect.vel.x)
      @rect.vel.y = Math.round(@rect.vel.y)
      return

    # Draw the player
    draw: (context)->
      @rect.update()
      @rect.draw(context)
      return
)
