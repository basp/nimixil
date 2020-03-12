import macros

dumpTree:
  method small*(x: SetVal): BoolVal {.inline.} =
    newBool(size(x).value < 2)