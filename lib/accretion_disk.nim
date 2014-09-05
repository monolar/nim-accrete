import star, dole

type
  AccretionDisk* = object
    star*: Star not nil

method innerBound*(this: AccretionDisk): float =
    return dole.innermostPlanet(this.star.mass)

method outerBound*(this: AccretionDisk): float =
    return dole.outermostPlanet(this.star.mass)

method innerDust*(this: AccretionDisk): float =
    return dole.innerDustLimit(this.star.mass)

method outerDust*(this: AccretionDisk): float =
    return dole.outerDustLimit(this.star.mass)
