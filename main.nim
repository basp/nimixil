import scan, parse, interp

while true:
  let src = stdin.readLine()
  let scanner = newScanner(src);
  let parser = newParser(scanner)
  let term = parser.parseTerm()
  for x in term: 
    eval(x)