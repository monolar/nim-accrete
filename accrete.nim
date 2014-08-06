# Accrete main file

import commandeer, times, math

import lib/generator

proc usage(): string =
  result = "Usage: accrete [--seed|-s=<seed>]"

commandLine:
  option seed, int, "seed", "s"
  exitoption "help", "h", usage()

when isMainModule:
  var
    effectiveSeed: int

  if seed != 0:
    effectiveSeed = seed
    echo "using seed '" & $effectiveSeed & "'"
  else:
    var now = times.epochTime()
    echo now
    effectiveSeed = math.round(100000000 * now)
    echo "using random seed '" & $effectiveSeed & "'"

  generator.generate(effectiveSeed)
