
define(['./creature'], (Creature)->

  # Player class
  #
  # For storing state of the player and drawing them
  #
  # Fields:
  #   rect - The bounding box of the player
  #   vel - The current velocity of the player
  class Player extends Creature

    constructor: ( w, h, @grid_pos, io) ->
      rect = new iio.Rect(@grid_pos, w, h).enableKinematics()
      rect.setFillStyle( '#00ee00' )

      super(rect, 2, io)
)
