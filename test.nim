import macros

type
  Operator* = enum
    opInt,
    opBool,
    opChar,
    opFloat,
    opString,
    opList,
    opIdent
  Factor* = object
    case op*: Operator
    of opBool: b*: bool
    of opInt: i*: int
    of opChar: c*: char
    of opFloat: f*: float
    of opString: s*: string
    of opList: list*: seq[Factor]
    of opIdent: id*: string