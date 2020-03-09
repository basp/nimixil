type 
  TokenKind* = enum
    tkNone,
    tkIllegal,
    tkEOF,
    tkIdent,
    tkInt,
    tkChar,
    tkFloat,
    tkString,
    tkList,
    tkLBrack,
    tkRBrack,
    tkLBrace,
    tkRBrace,
    tkColon,
    tkSemicolon,
  Token = object
    kind*: TokenKind
    lexeme*: string
    pos*: int
  Scanner = ref object
    src: string
    pos: int
    readPos: int
    ch: char

proc initToken(kind: TokenKind, lexeme: string, pos: int): Token =
  result.kind = kind
  result.lexeme = lexeme
  result.pos = pos

proc advance(s: Scanner) =
  if s.readPos >= len(s.src):
    s.ch = char(0)
  else:
    s.ch = s.src[s.readPos]
  s.pos = s.readPos
  s.readPos += 1

proc isWhitespace(ch: char): bool =
  ch == ' ' or ch == '\t' or ch == '\n' or ch == '\r'

proc skipWhitespace(s: Scanner) =
  while isWhitespace(s.ch):
    s.advance()
    
proc readIdent(s: Scanner): string =
  let pos = s.pos
  while not isWhitespace(s.ch) and s.ch != char(0):
    s.advance()
  s.src[pos..<s.pos]

proc nextToken*(s: Scanner): Token =
  s.skipWhitespace()
  case s.ch
  of '[': result = initToken(tkLBrack, "[", s.pos)
  of ']': result = initToken(tkRBrack, "]", s.pos)
  of '{': result = initToken(tkLBrace, "{", s.pos)
  of '}': result = initToken(tkRBrace, "}", s.pos)
  of ':': result = initToken(tkColon, ":", s.pos)
  of ';': result = initToken(tkSemicolon, ";", s.pos)
  of char(0):
    result.lexeme = ""
    result.kind = tkEOF
  else:
    result.pos = s.pos
    result.lexeme = s.readIdent()
    result.kind = tkIdent
    return
  s.advance()

proc newScanner*(src: string): Scanner =
  result = new(Scanner)
  result.src = src
  result.advance()