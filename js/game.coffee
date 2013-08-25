# Main File
#
# Author: Calum Gilchrist

require(['js/lib/iioengine/core/iioEngine.js',
          'js/lib/iioengine/extensions/iioDebugger.js',
          'js/player',
          'js/agent',
          'js/utility'], (iioengine, iiodebugger, Player, Agent, Utility) ->

  # Create a group of agents and add them to the list
  #
  # agent_list - Array to add the new agents to
  # enemy_list - A list of agents in the opposite number
  create_agents = (agent_list, , team_size)->

    # Create agent creatures
    for x in [0..team_size]
      agent = new Agent( new iio.Vec(
        iio.getRandomInt(0, io.canvas.width),
        iio.getRandomInt(0, io.canvas.height)),
        cell_size,
        io )
      io.addToGroup('agent', agent.rect, 2)
      io.addToGroup('creatures', agent.rect, 2)
      
      agent_list.push agent


  add_goals = (agent_list, enemy_list) ->
    # FIXME: Circular dependency in enemy list,
    # new function required
    for agent in enemies
      agent.goal = allies[iio.getRandomInt(0, allies.length)].rect.pos



  main = (io) ->

    #io.activateDebugger()

    creatures = []
    enemies = []
    allies = []
    cell_size = 16
    team_size = 5

    # Set up obj
    start_point = new iio.Vec(io.canvas.center)

    player = new Player( cell_size, cell_size, start_point, io )
    io.addToGroup('player', player.rect, 1)
    io.addToGroup('creatures', player.rect, 1)

    creatures.push player

    # Create ally creatures
    for x in [0..team_size - 1]
      ally = new Agent( new iio.Vec(
        iio.getRandomInt(0, io.canvas.width),
        iio.getRandomInt(0, io.canvas.height)),
        cell_size,
        io )
      ally.rect.setFillStyle('blue') 
      io.addToGroup('ally', ally.rect, 2)
      io.addToGroup('creatures', ally.rect, 2)

      allies.push ally

    allies.push player

    for ally in allies
      ally.goal = enemies[iio.getRandomInt(0, enemies.length)].rect.pos

    # Create enemy creatures
    for x in [0..team_size]
      enemy = new Agent( new iio.Vec(
        iio.getRandomInt(0, io.canvas.width),
        iio.getRandomInt(0, io.canvas.height)),
        cell_size,
        io )
      io.addToGroup('enemy', enemy.rect, 2)
      io.addToGroup('creatures', enemy.rect, 2)
      
      enemies.push enemy

    for enemy in enemies
      enemy.goal = allies[iio.getRandomInt(0, allies.length)].rect.pos

    creatures = creatures.concat(enemies)
    creatures = creatures.concat(allies)

    # Setup map
    map_width = Math.round( io.canvas.width / cell_size )
    map_height = Math.round( io.canvas.height / cell_size )

    map = new iio.Grid( 0, 0, map_width, map_height, cell_size, cell_size)
    map.setLineWidth(2)
    map.setStrokeStyle('#2e2e2e')


    walls = []

    # Generate random walls
    for i in [0..20]
      # 5 is a reasonable number, should be made statistically
      walls.push [
        iio.getRandomInt(0, map.R - 1),
        iio.getRandomInt(0, map.C - 1),
        iio.getRandomInt(1, 3)]


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
