import scan

let scanner = newScanner("foo '#234' 'c' bar[] bra \"breotz foz\" frotz")
var tok = scanner.nextToken()
while tok.kind != tkEOF:
  echo $tok.kind & " " & tok.lexeme & " " & $tok.pos
  tok = scanner.nextToken()
