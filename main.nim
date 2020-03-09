import scan

let scanner = newScanner("foo bar")
var tok = scanner.nextToken()
echo tok.kind
echo tok.lexeme
tok = scanner.nextToken()
echo tok.kind
echo tok.lexeme
tok = scanner.nextToken()
echo tok.kind
echo tok.lexeme
tok = scanner.nextToken()
echo tok.kind
echo tok.lexeme
