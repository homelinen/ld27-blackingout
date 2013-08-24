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


  class Player

    constructor: ( w, h, @grid_pos) ->
      @rect= new iio.Rect(@grid_pos, w, h).enableKinematics()
      @rect.setFillStyle( '#00ee00' )
      @vel = new iio.Vec(0,0)

    move: (x, y)->
      @vel.add(x,y)
      @rect.setVel(@vel)
      return

    # Update the logic attributes
    update: ->
      temp_vel = @vel.clone()
      temp_vel = safe_normalize(temp_vel)
      console.log(temp_vel.toString())

      @vel.sub(temp_vel)
      Math.round(@vel)
      @rect.setVel(@vel)
      return

    # Draw the player
    draw: (context)->
      @rect.update()
      @rect.draw(context)
      return

  main = (io) ->

    # Set up obj
    player = new Player( 32, 32, 0, 0 )

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

  iio.start(main)
  return
)
