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

    # Setup map
    map = new iio.Grid( 0,0, 10, 10, cell_size, cell_size)
    map.setLineWidth(2)
    map.setStrokeStyle('#2e2e2e')

    console.log 'map'
    console.log map

    walls = [
      [2,2,1],
      [3,3,3],
      [10,4,6],
      [4,1,2]
    ]

    i=0
    j=0
    for row in map.cells
      j = 0
      for cell in row
        for wall in walls
          console.log("i: " + i + " j: " + j)
          if (i >= wall[0] and i <= wall[0] + wall[2] and j >= wall[1] and j <= wall[1] + wall[2])
            cell.isPassable = false
          else
            cell.isPassable = true
        j++
      i++

    console.log(map.cells)

    background_img = new Image()
    background_img.src = 'img/floor.png'
    background_img.onload = ->
      background = new iio.Rect().createWithImage(background_img)

      #io.addCanvas(-10)
      #io.addObj(background)
      #io.draw(1)

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

    # Drawing
    io.setFramerate(40, ->
      io.draw()

      player.draw(io.context)

      for enemy in enemies
        enemy.draw(io.context)
      return
    )

    io.addCanvas(-5)
    temp_rect = new iio.Rect()
    i=0
    j=0

    # Drawing grid
    for row in map.cells
      j=0
      for cell in row
        if not cell.isPassable
          temp_rect = new iio.Rect(new iio.Vec(i * map.res.x, j * map.res.y), map.res.x)
          temp_rect.setFillStyle('#2e2e2e')
          io.addObj(temp_rect, 0, 1)
        j++
      i++

    return

  iio.start(main, 800, 600)
  return
)
