# Main File
#
# Author: Calum Gilchrist

require(['js/lib/iioengine/core/iioEngine.js'], (iioengine) ->

  main = (io) ->

    # Set up obj
    player_rect = new iio.Rect( 50, 50 , 32, 32 )
    player_rect.setFillStyle( '#00ee00' )

    grid = new iio.Grid( 0,0, 20, 15, 32, 32 )
    grid.setLineWidth(2)
    grid.setStrokeStyle('2e2e2e')


    # Set up keyboard
    window.addEventListener('keydown', (event) ->
      new_pos = player_rect.pos.clone()
      
      if iio.keyCodeIs 'right arrow', event
        player_rect.translate(32, 0)
        return
      else if iio.keyCodeIs 'left arrow', event
        player_rect.translate(-32, 0)
        return
      else if iio.keyCodeIs 'up arrow', event
        player_rect.translate(0, -32)
        return
      else if iio.keyCodeIs 'down arrow', event
        player_rect.translate(0, 32)
        return
 
    )

    # Drawing
    io.setFramerate(40, ->
      io.draw()

      grid.draw(io.context)
      player_rect.draw(io.context)
      return
    )

    return

  iio.start(main)
  return
)
