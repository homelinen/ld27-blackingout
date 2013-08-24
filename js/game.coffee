# Main File
#
# Author: Calum Gilchrist

require(['js/lib/iioengine/core/iioEngine.js',
          'js/lib/iioengine/extensions/iioDebugger.js',
          'js/player',
          'js/enemy'], (iioengine, iiodebugger, Player, Enemy) ->


  main = (io) ->

    io.activateDebugger()

    # Set up obj
    start_point = new iio.Vec(0,0)

    player = new Player( 32, 32, start_point, io )
    io.addToGroup('player', player.rect, 1)
    enemy = new Enemy( io )
    io.addToGroup('enemy', enemy.rect, 2)

    grid = new iio.Grid( 0,0, 50, 50, 32, 32 )
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

    # Collisions
    io.setCollisionCallback('player', 'enemy', (obj1, obj2) ->
      console.log("SMASH")
    )

    # Logic
    io.setFramerate(20, ->
      player.update()
      enemy.update()
    )

    # Drawing
    io.setFramerate(40, ->
      io.draw()

      grid.draw(io.context)
      player.draw(io.context)
      enemy.draw(io.context)
      return
    )

    return

  iio.start(main, 800, 600)
  return
)
