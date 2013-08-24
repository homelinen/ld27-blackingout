
define([], ->

  class Utility

  # Normalise a vector, but handle division by 0
  Utility.safe_normalize= (vec) ->
    vec.normalize()
    vec.x = @reset_null(vec.x)
    vec.y = @reset_null(vec.y)

    return vec

  # If a value is null, set it to 0
  #
  # Returns original number or 0
  Utility.reset_null = (num) ->
    if isNaN(num)
      num = 0

    return num

  return Utility
)
