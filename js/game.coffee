# Main File
#
# Author: Calum Gilchrist

require(['js/lib/iioengine/core/iioEngine.js',
          'js/lib/iioengine/extensions/iioDebugger.js',
          'js/player',
          'js/enemy'], (iioengine, iiodebugger, Player, Enemy) ->


  main = (io) ->

    io.activateDebugger()

    creatures = []
    enemies = []
    cell_size = 16

    # Set up obj
    start_point = new iio.Vec(0,0)

    player = new Player( cell_size, cell_size, start_point, io )
    io.addToGroup('player', player.rect, 1)

    creatures.push player

    for x in [0..9]
      enemy = new Enemy( new iio.Vec(
        iio.getRandomInt(0, io.canvas.width),
        iio.getRandomInt(0, io.canvas.height)),
        cell_size,
        io )
      io.addToGroup('enemy', enemy.rect, 2)
      
      enemies.push enemy

    creatures = creatures.concat(enemies)

    for enemy in enemies
      enemy.goal = creatures[iio.getRandomInt(0, enemies.length)].rect.pos

    grid = new iio.Grid( 0,0, 50, 50, cell_size, cell_size )
    grid.setLineWidth(2)
    grid.setStrokeStyle('#2e2e2e')

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
    )

    # Logic
    io.setFramerate(20, ->
      player.update()
      for enemy in enemies
        enemy.update()
    )

    # Drawing
    io.setFramerate(40, ->
      io.draw()

      grid.draw(io.context)
      player.draw(io.context)

      for enemy in enemies
        enemy.draw(io.context)
      return
    )

    return

  iio.start(main, 800, 600)
  return
)
