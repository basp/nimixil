import math, tables, strutils, scan, runtime2

type
  Parser = ref object
    s: Scanner
    curTok: Token
    nextTok: Token

proc advance(p: Parser) =
  p.curTok = p.nextTok
  p.nextTok = p.s.nextToken()

var reserved = initTable[string, proc(): Value]()
reserved.add("true", proc(): Value = newBool(true))
reserved.add("false", proc(): Value = newBool(false))
reserved.add("pi", proc(): Value = newFloat(math.PI))
reserved.add("tau", proc(): Value = newFloat(math.TAU))
reserved.add("e", proc(): Value = newFloat(math.E))

proc parseIdent(p: Parser): Value =
  if reserved.hasKey(p.curTok.lexeme):
    result = reserved[p.curTok.lexeme]()
  else:
    result = newIdent(p.curTok.lexeme)
  p.advance()

proc parseChar(p: Parser): Value =
  # TODO:
  # fancier string to char conversion; this 
  # assumes all char literals look like 'c'
  proc convert(s: string): char = s[1]
  let c = convert(p.curTok.lexeme)
  result = newChar(c)
  p.advance()

proc parseString(p: Parser): Value =
  let s = p.curTok.lexeme.strip(chars = {'"'})
  result = newString(s)
  p.advance()

proc tryParseInt(s: string): (bool, int) =
  try:
    let i = strutils.parseInt(s)
    result = (true, i)
  except:
    result = (false, 0)

proc parseNumber(p: Parser): Value =
  let s = p.curTok.lexeme
  let (ok, i) = tryParseInt(s)
  if ok:
    result = newInt(i)
    p.advance()
    return
  # if we can't parse it as an int we'll
  # force parse it as a float instead
  try:
    let f = parseFloat(p.curTok.lexeme)
    result = newFloat(f)
    p.advance()
    return
  except:
    raise newException(Exception, "bad numeric");

proc parseFactor(p: Parser): Value

proc parseList(p: Parser): Value =
  var terms : seq[Value] = @[]
  p.advance()
  while p.curTok.kind != tkRBrack:
    let fac = p.parseFactor()
    terms.add(fac)
  if p.curTok.kind == tkRBrack:
    p.advance()
  newList(terms)

proc parseSet(p: Parser): Value =
  var s = newSet(0)
  p.advance()
  while p.curTok.kind != tkRBrace:
    let i = parseInt(p.curTok.lexeme)
    s.add(i)
    p.advance()
  if p.curTok.kind == tkRBrace:
    p.advance()
  return s

proc parseFactor(p: Parser): Value =
  case p.curTok.kind
  of tkLBrack: p.parseList()
  of tkLBrace: p.parseSet()
  of tkNumber: p.parseNumber()
  of tkChar: p.parseChar()
  of tkString: p.parseString()
  of tkIdent: p.parseIdent()
  else: 
    # this will most likely be caused by
    # an unterminated literal and it's
    # highly likely we'll be hitting tkEOF
    raise newException(Exception, $p.curTok.kind)

proc parseTerm*(p: Parser): seq[Value] =
  result = @[]
  while(p.curTok.kind != tkEOF):
    let fac = p.parseFactor()
    result.add(fac)

proc newParser*(s: Scanner): Parser =
  result = new(Parser)
  result.s = s
  result.advance()
  result.advance()