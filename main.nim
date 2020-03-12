import lists, scan, parse, interp2, runtime2

while true:
  stdout.write("< ")
  let src = stdin.readLine()
  let scanner = newScanner(src);
  let parser = newParser(scanner)
  try:
    let term = parser.parseTerm()
    for x in term:
      eval(x)
    echo "."
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
