import lists, scan, parse, interp2

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
    for x in stack:
      echo repr(x)
  except Exception:
    let
      e = getCurrentException()
      msg = getCurrentExceptionMsg()
    echo "Exception: ", repr(e), " with message ", msg