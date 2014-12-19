import oopmacro
import math

const SOLAR_MASS*: float = 1.0

class Star of RootObj:
  var mass*: float # in solar masses M☉

  # returns the luminosity of a star in solar luminosities L☉
  method luminosity*: float {.inline.} =
    var
      n: float

    if this.mass < SOLAR_MASS:
      n = 1.75 * (this.mass - 0.1) + 3.325
    else:
      n = 0.5 * (2.0 - this.mass) + 4.4
    return math.pow(this.mass, n)

  # returns the luminosity of a star in solar luminosities L☉
  # http://en.wikipedia.org/wiki/Mass%E2%80%93luminosity_relation
  # Only valid for stars with mass > 0.08 M☉ and mass < 100 M☉
  # -> Only valif for main sequence stars
  method luminosity2*: float {.raises: [ValueError] inline.} =
    if (this.mass < 0.08 * SOLAR_MASS):
      raise newException(ValueError, "Star is too light! mass:'" & $this.mass & "' is smaller than '0.08'")
    elif (this.mass >= 0.08 * SOLAR_MASS) and (this.mass < 0.43 * SOLAR_MASS):
      return 0.23 * math.pow(this.mass / SOLAR_MASS, 2.3)
    elif (this.mass >= 0.43 * SOLAR_MASS) and (this.mass < 2.0 * SOLAR_MASS):
      return math.pow(this.mass / SOLAR_MASS, 4)
    elif (this.mass >= 2.0 * SOLAR_MASS) and (this.mass < 20 * SOLAR_MASS):
      return 1.5 * math.pow(this.mass / SOLAR_MASS, 3.5)
    elif (this.mass >= 20.0 * SOLAR_MASS):
      return 3200 * (this.mass / SOLAR_MASS)
    else:
      raise newException(EInvalidValue, "Star is too heavy! mass:'" & $this.mass & "' is larger than '100'")

export Star

# Most important instance as constant here: Our Sun
let sun* = Star(mass : SOLAR_MASS)
