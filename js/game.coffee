# Main File
#
# Author: Calum Gilchrist

require(['js/lib/iioengine/core/iioEngine.js'], (iioengine) ->

  # Normalise a vector, but handle division by 0
  safe_normalize = (vec) ->
    vec.normalize()
    vec.x = reset_null(vec.x)
    vec.y = reset_null(vec.y)

    return vec

  # If a value is null, set it to 0
  #
  # Returns original number or 0
  reset_null = (num) ->
    if isNaN(num)
      num = 0

    return num

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
        { dir: 'left',
          x: 6, y: 0,
          constraint: 0 },
        { dir: 'right',
          x: -6, y: 0,
          constraint: io.canvas.width },
        { dir: 'top',
          x: 0, y: 6,
          constraint: 0 },
        { dir: 'bottom',
          x: 0,
          y: -6,
          constraint: io.canvas.height }
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
      temp_vel = safe_normalize(temp_vel)

      @rect.vel.sub(temp_vel)
      @rect.vel.x = Math.round(@rect.vel.x)
      @rect.vel.y = Math.round(@rect.vel.y)
      return

    # Draw the player
    draw: (context)->
      @rect.update()
      @rect.draw(context)
      return

  main = (io) ->

    # Set up obj
    start_point = new iio.Vec(0,0)

    player = new Player( 32, 32, start_point, io )

    grid = new iio.Grid( 0,0, 20, 15, 32, 32 )
    grid.setLineWidth(2)
    grid.setStrokeStyle('2e2e2e')

    # Set up keyboard
    window.addEventListener('keydown', (event) ->
      movement=6
      
      if iio.keyCodeIs 'right arrow', event
        player.move(movement, 0)
        return
      else if iio.keyCodeIs 'left arrow', event
        player.move(-movement, 0)
        return
      else if iio.keyCodeIs 'up arrow', event
        player.move(0, -movement)
        return
      else if iio.keyCodeIs 'down arrow', event
        player.move(0, movement)
        return
    )

    # Logic
    io.setFramerate(20, ->
      player.update()
    )

    # Drawing
    io.setFramerate(40, ->
      io.draw()

      grid.draw(io.context)
      player.draw(io.context)
      return
    )

    return

  iio.start(main, 200, 400)
  return
)
