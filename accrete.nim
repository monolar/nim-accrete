# Accrete main file

import os, tables, strutils, commandeer

commandline:
  exitoption "help", "h",
             "Usage: ..."

# Parses the command line parameters.
# Strings containing '=' are interpreted as value assignments
# Strings not containing '=' are interpreted as flags set to 'true'
# returns TTable[string, string] with the result
proc parseCommandlineParams(): TTable[string, string] =
  var rawParams: TTable[string, string] = initTable[string, string]()
  # ignore paramIndex 0 since it is the executable
  for paramIndex in 1..paramCount():
    if find(paramStr(paramIndex), '=') == -1:
      rawParams.add(paramStr(paramIndex), "true")
    else:
      var segments = split(paramStr(paramIndex), '=')
      rawParams.add(segments[0], segments[1])
  rawParams

proc usage() =
  echo "usage..."

#when isMainModule:
#  echo "mainmodule"
#  var rawParams = parseCommandlineParams()
#  if rawParams.len() == 0:
#    usage()
#  else:
#    for key in rawParams.keys:
#      echo key & "='" & rawParams[key] & "'"
