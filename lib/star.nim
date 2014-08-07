import math

type
  Star* = object
    mass*: float # in solar masses M☉

# Most important instance as constant here: Our Sun
let sun* = Star(mass : 1.0)

# returns the luminosity of a star in solar luminosities L☉
method luminosity*(this: Star): float {.inline.} =
  var
    n: float

  if this.mass < sun.mass:
    n = 1.75 * (this.mass - 0.1) + 3.325
  else:
    n = 0.5 * (2.0 - this.mass) + 4.4
  return math.pow(this.mass, n)

# returns the luminosity of a star in solar luminosities L☉
# http://en.wikipedia.org/wiki/Mass%E2%80%93luminosity_relation
# Only valid for stars with mass > 0.08 M☉ and mass < 100 M☉
# -> Only valif for main sequence stars
method luminosity2*(this: Star): float {.raises: [EInvalidValue] inline.} =
  if (this.mass < 0.08 * sun.mass):
    raise newException(EInvalidValue, "Star is too light! mass:'" & $this.mass & "' is smaller than '0.08'")
  elif (this.mass >= 0.08 * sun.mass) and (this.mass < 0.43 * sun.mass):
    return 0.23 * Math.pow(this.mass / sun.mass, 2.3)
  elif (this.mass >= 0.43 * sun.mass) and (this.mass < 2.0 * sun.mass):
    return Math.pow(this.mass / sun.mass, 4)
  elif (this.mass >= 2.0 * sun.mass) and (this.mass < 20 * sun.mass):
    return 1.5 * Math.pow(this.mass / sun.mass, 3.5)
  elif (this.mass >= 20.0 * sun.mass):
    return 3200 * (this.mass / sun.mass)
  else:
    raise newException(EInvalidValue, "Star is too heavy! mass:'" & $this.mass & "' is larger than '100'")
