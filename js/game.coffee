# Main File
#
# Author: Calum Gilchrist

require(['js/lib/iioengine/core/iioEngine.js',
          'js/player'], (iioengine, Player) ->


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
