import scan, parse

while true:
  let src = stdin.readLine()
  let scanner = newScanner(src);
  let parser = newParser(scanner)
  let term = parser.parseTerm()
  for x in term:
    echo x