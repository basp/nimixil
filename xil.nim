import lists, scan, parse, interp, runtime

while true:
  stdout.write("< ")
  let src = stdin.readLine()
  var scanner = newScanner(src);
  let parser = newParser(scanner)
  try:
    var (ok, def) = parser.tryParseDef()
    if ok:
      eval(def)
    else:
      let term = parser.parseTerm()
      for x in term: eval(x)
  except RuntimeException:
    let msg = getCurrentExceptionMsg()
    echo "Runtime error: ", msg
  except Exception:
    let
      e = getCurrentException()
      msg = getCurrentExceptionMsg()
    echo "Exception: ", repr(e), " with message ", msg
  finally:
    for x in stack:
      echo x
