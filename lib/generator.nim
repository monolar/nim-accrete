import mersenne, dole, star, accretion_disk

proc generate*(seed: int) =
  var mt = newMersenneTwister(seed)

  var myStar = Star(mass: 3.0)
  echo repr(myStar)
  var ad = AccretionDisk(star: myStar)

  echo repr(ad)

  echo "done"
