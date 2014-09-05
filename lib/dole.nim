import math

proc scaleCubeRootMass(scale: float, mass: float): float =
  return scale * Math.pow(mass, 1.0/3.0)

proc innermostPlanet*(stellar_mass: float): float =
  return scaleCubeRootMass(0.3, stellar_mass)

proc outermostPlanet*(stellar_mass: float): float =
  return scaleCubeRootMass(50.0, stellar_mass)


proc innerDustLimit*(stellar_mass: float): float =
  return 0.0

proc outerDustLimit*(stellar_mass: float): float =
  return scaleCubeRootMass(200.0, stellar_mass)
