import lists, scan, parse, interp

while true:
  let src = stdin.readLine()
  let scanner = newScanner(src);
  let parser = newParser(scanner)
  try:
    let term = parser.parseTerm()
    for x in term:
      eval(x)
    for x in stack:
      echo x
  except Exception:
    let
      e = getCurrentException()
      msg = getCurrentExceptionMsg()
    echo "Exception: ", repr(e), " with message ", msg