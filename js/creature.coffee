
define(['js/utility'], (Utility) ->

  class Creature

    constructor: ( @rect, @speed, io ) ->

      # Define velocity if not already done
      if @rect.vel == undefined
        @rect.setVel(0,0)

      bound_options = [
         left =
           dir: 'left',
           x: @speed,
           y: 0,
           constraint: 0 ,
         right =
           dir: 'right',
           x: -@speed,
           y: 0,
           constraint: io.canvas.width ,
         top =
           dir: 'top',
           x: 0,
           y: @speed,
           constraint: 0 ,
         bottom =
           dir: 'bottom',
           x: 0,
           y: -@speed,
           constraint: io.canvas.height
      ]

      for bound in bound_options
        do (bound, @rect) ->
          @rect.setBound(bound.dir, bound.constraint, (obj) ->
            obj.vel.x = bound.x
            obj.vel.y = bound.y
            return true
          )

    move: (x, y)->
      @rect.vel.add(x,y)
      return

    # Update the logic attributes
    update: ->
      @smooth_movement()

      @rect.update()
      return

    # Draw the player
    draw: (context)->
      @rect.draw(context)
      return

    smooth_movement: ->
      temp_vel = @rect.vel.clone()
      temp_vel = Utility.safe_normalize(temp_vel)

      @rect.vel.sub(temp_vel)
      @rect.vel.x = Math.round(@rect.vel.x)
      @rect.vel.y = Math.round(@rect.vel.y)
)
