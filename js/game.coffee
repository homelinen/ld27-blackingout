# Main File
#
# Author: Calum Gilchrist

require(['js/lib/iioengine/core/iioEngine.js'], (iioengine) ->

  class Player

    constructor: ( w, h, @grid_pos) ->
      @rect= new iio.Rect(@grid_pos, w, h)
      @rect.setFillStyle( '#00ee00' )

    move: (x, y)->
      @rect.translate(x, y)

    # Draw the player
    draw: (context)->
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
