# Main File
#
# Author: Calum Gilchrist

require(['js/lib/iioengine/core/iioEngine.js',
          'js/lib/iioengine/extensions/iioDebugger.js',
          'js/player',
          'js/enemy',
          'js/utility'], (iioengine, iiodebugger, Player, Enemy, Utility) ->

  main = (io) ->

    #io.activateDebugger()

    creatures = []
    enemies = []
    cell_size = 16

    # Set up obj
    start_point = new iio.Vec(io.canvas.center)

    player = new Player( cell_size, cell_size, start_point, io )
    io.addToGroup('player', player.rect, 1)
    io.addToGroup('creatures', player.rect, 1)

    creatures.push player

    for x in [0..9]
      enemy = new Enemy( new iio.Vec(
        iio.getRandomInt(0, io.canvas.width),
        iio.getRandomInt(0, io.canvas.height)),
        cell_size,
        io )
      io.addToGroup('enemy', enemy.rect, 2)
      io.addToGroup('creatures', enemy.rect, 2)
      
      enemies.push enemy

    creatures = creatures.concat(enemies)

    for enemy in enemies
      enemy.goal = creatures[iio.getRandomInt(0, enemies.length)].rect.pos

    # Setup map
    map_width = Math.round( io.canvas.width / cell_size )
    map_height = Math.round( io.canvas.height / cell_size )

    map = new iio.Grid( 0, 0, map_width, map_height, cell_size, cell_size)
    map.setLineWidth(2)
    map.setStrokeStyle('#2e2e2e')

    walls = [
      [2,2,1],
      [4,3,2],
      [10,4,6],
      [8,1,1],
      [2,8,3]
    ]

    i=0
    j=0
    for row in map.cells
      j = 0
      for cell in row
        for wall in walls
          if (i >= wall[0] and i <= wall[0] + wall[2] and j >= wall[1] and j <= wall[1] + wall[2])
            cell.isPassable = false
            map.cells[i][j] = cell
            # Ensure the flag isn't reset
            break
          else
            map.cells[i][j] = cell
            cell.isPassable = true
        j++
      i++

    background_img = new Image()
    background_img.src = 'img/floor.png'
    background_img.onload = ->
      background = new iio.Rect().createWithImage(background_img)

      io.addObj(background, -20)

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
      player.update(map)
      for enemy in enemies
        enemy.update(map)
    )

    temp_rect = new iio.Rect()
    i=0
    j=0

    # Drawing grid
    # Create a new rect for each impassible cell
    for row in map.cells
      j=0
      for cell in row
        if not cell.isPassable
          temp_rect = new iio.Rect(
            new iio.Vec(i * map.res.x,
              j * map.res.y), 
            map.res.x)
          .setFillStyle('#2e2e2e')

          io.addToGroup('walls', temp_rect)

          io.addObj(temp_rect, 50)
        j++
      i++

    io.addObj(map,-2, 0)

    # Drawing
    io.setFramerate(40, ->
      io.draw()

      player.draw(io.context)

      for enemy in enemies
        enemy.draw(io.context)
      return
    )

    return

  iio.start(main, 800, 600)
  return
)
