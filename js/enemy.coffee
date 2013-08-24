
define(['./creature'], (Creature) ->

  class Enemy extends Creature

    constructor: (io) ->
      rect = new iio.Rect(io.canvas.center, 32).enableKinematics()
      rect.setFillStyle( '#ee0000' )

      super( rect, 6, io )

      rect.vel.x = @speed

      @rect.bounds.right.callback = (obj) ->
        obj.vel.x = - obj.vel.x


    update: ->

      @rect.update() 

)
