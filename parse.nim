import strutils, tables, scan

type
  Operator = enum
    opInt,
    opBool,
    opChar,
    opFloat,
    opString,
    opList,
    opIdent
  Factor = object
    case op: Operator
    of opBool: b: bool
    of opInt: i: int
    of opChar: c: char
    of opFloat: f: float
    of opString: s: string
    of opList: list: seq[Factor]
    of opIdent: id: string
  Parser = ref object
    s: Scanner
    curTok: Token
    nextTok: Token

proc initBool(x: bool): Factor =
  Factor(op: opBool, b: x)

proc initInt(x: int): Factor =
  Factor(op: opInt, i: x)

proc initFloat(x: float): Factor =
  Factor(op: opFloat, f: x)

proc initChar(x: char): Factor =
  Factor(op: opChar, c: x)

proc initString(x: string): Factor =
  Factor(op: opString, s: x)

proc initIdent(x: string): Factor =
  Factor(op: opIdent, id: x)

proc initList(x: seq[Factor]): Factor =
  Factor(op: opList, list: x)

proc advance(p: Parser) =
  p.curTok = p.nextTok
  p.nextTok = p.s.nextToken()

var reserved = initTable[string, proc(): Factor]()
reserved.add("true", proc(): Factor =
  initBool(true))
reserved.add("false", proc(): Factor =
  initBool(false))

proc parseIdent(p: Parser): Factor =
  if reserved.hasKey(p.curTok.lexeme):
    result = reserved[p.curTok.lexeme]()
  else:
    result = initIdent(p.curTok.lexeme)
  p.advance()

proc parseChar(p: Parser): Factor =
  # TODO:
  # fancier string to char conversion;
  # this assumes basic char literals like 'c'
  proc convert(s: string): char = s[1]
  let c = convert(p.curTok.lexeme)
  result = initChar(c)
  p.advance()

proc parseString(p: Parser): Factor =
  result = initString(p.curTok.lexeme)
  p.advance()

proc tryParseInt(s: string): (bool, int) =
  try:
    let i = parseInt(s)
    result = (true, i)
  except:
    result = (false, 0)

proc parseNumber(p: Parser): Factor =
  let s = p.curTok.lexeme
  let (ok, i) = tryParseInt(s)
  if ok:
    result = initInt(i)
    p.advance()
    return
  # if we can't parse it as an int we'll
  # try to parse it as a float instead,
  # if that doesn't work we'll raise an error
  try:
    let f = parseFloat(p.curTok.lexeme)
    result = initFloat(f)
    p.advance()
    return
  except:
    raise newException(Exception, "bad numeric");

proc parseFactor(p: Parser): Factor

proc parseList(p: Parser): Factor =
  var terms : seq[Factor] = @[]
  p.advance() # skip over [
  while p.curTok.kind != tkRBrack:
    let fac = p.parseFactor()
    terms.add(fac)
  # throw on unterminated?
  if p.curTok.kind == tkRBrack:
    p.advance()
  return initList(terms)

proc parseFactor(p: Parser): Factor =
  case p.curTok.kind
  of tkLBrack: p.parseList()
  of tkNumber: p.parseNumber()
  of tkChar: p.parseChar()
  of tkString: p.parseString()
  of tkIdent: p.parseIdent()
  else: raise newException(Exception, $p.curTok.kind)

proc parseTerm*(p: Parser): seq[Factor] =
  result = @[]
  while(p.curTok.kind != tkEOF):
    let fac = p.parseFactor()
    result.add(fac)

proc newParser*(s: Scanner): Parser =
  result = new(Parser)
  result.s = s
  result.advance()
  result.advance()
