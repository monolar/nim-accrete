import mersenne

proc generate*(seed: int) =
  var mt = newMersenneTwister(seed)
  for i in 0..4:
    echo mt.getNum
