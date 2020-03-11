import lists, runtime

const 
  ID = "id"
  DUP = "dup"
  SWAP = "swap"
  ROLLUP = "rollup"
  ROLLDOWN = "rolldown"
  ROTATE = "rotate"
  POP = "pop"
  PEEK = "peek"
  PUT = "put"
  CHOICE = "choice"
  CMP = "cmp"
  OR ="or"
  XOR = "xor"
  AND = "and"
  NOT = "not"
  ADD = "+"
  SUB = "-"
  MUL = "*"
  DIVF = "/"
  REM = "rem"
  DIV = "div"
  SIGN = "sign"
  NEG = "neg"
  ORD = "ord"
  CHR = "chr"
  ABS = "abs"
  ACOS = "acos"
  ASIN = "asin"
  ATAN = "atan"
  COS = "cos"
  COSH = "cosh"
  SIN = "sin"
  SINH = "sinh"
  SQRT = "sqrt"
  TAN = "tan"
  TANH = "tanh"
  PRED = "pred"
  SUCC = "succ"
  MAX = "max"
  MIN = "min"
  CONS = "cons"
  SWONS = "swons"
  FIRST = "first"
  REST = "rest"
  AT = "at"
  OF = "of"
  SIZE = "size"
  UNCONS = "uncons"
  UNSWONS = "unswons"
  I = "i"
  X = "x" 
  DIP = "dip"
  APP1 = "app1"
  NULLARY = "nullary"
  UNARY = "unary"
  BINARY = "binary"
  TERNARY = "ternary"
  UNARY2 = "unary2"
  UNARY3 = "unary3"
  UNARY4 = "unary4"

var 
  stack* = initSinglyLinkedList[Value]()
  saved = initSinglyLinkedList[Value]()

# template saved1() = saved.head
template saved2() = saved.head.next
template saved3() = saved.head.next.next
template saved4() = saved.head.next.next.next
template saved5() = saved.head.next.next.next.next
template saved6() = saved.head.next.next.next.next.next

method eval*(x: Value) {.base,locks:0.}

proc execterm(p: ListVal) =
  for x in p.elements:
    eval(x)

proc push(x: Value) {.inline.} =
  let node = newSinglyLinkedNode(x)
  stack.prepend(node)

proc pop(): Value {.inline.} =
  result = stack.head.value
  stack.head = stack.head.next

proc peek(): Value {.inline.} =
  stack.head.value

proc popt[T](): T {.inline.} = 
  cast[T](pop())

proc peekt[T](): T {.inline.} = 
  cast[T](peek())

method floatable(x: Value): bool {.base,inline.} = false
method floatable(x: IntVal): bool {.inline.} = true
method floatable(x: FloatVal): bool {.inline.} = true

method integer(x: Value): bool {.base,inline.} = false
method integer(x: IntVal): bool {.inline.} = true

method logical(x: Value): bool {.base,inline.} = false
method logical(x: BoolVal): bool {.inline.} = true
method logical(x: SetVal): bool {.inline.} = true

method ordinal(x: Value): bool {.base,inline.} = false
method ordinal(x: BoolVal): bool {.inline.} = true
method ordinal(x: IntVal): bool {.inline.} = true
method ordinal(x: CharVal): bool {.inline.} = true

method aggregate(x: Value): bool {.base,inline.} = false
method aggregate(x: ListVal): bool {.inline.} = true
method aggregate(x: SetVal): bool {.inline.} = true
method aggregate(x: StringVal): bool {.inline.} = true

method list(x: Value): bool {.base,inline.} = false
method list(x: ListVal): bool {.inline.} = true

proc oneParameter(name: string) {.inline.} =
  doAssert stack.head != nil, name

proc twoParameters(name: string) {.inline.} =
  oneParameter(name)
  doAssert stack.head.next != nil, name

proc threeParameters(name: string) {.inline.} =
  twoParameters(name)
  doAssert stack.head.next.next != nil, name

proc fourParameters(name: string) {.inline.} =
  threeParameters(name)
  doAssert stack.head.next.next.next != nil, name

proc fiveParameters(name: string) {.inline.} =
  fourParameters(name)
  doAssert stack.head.next.next.next.next != nil, name

proc integer(name: string) {.inline.} =
  doAssert stack.head.value.integer

proc integerAsSecond(name: string) {.inline.} =
  doAssert stack.head.next.value.integer

proc twoIntegers(name: string) {.inline.} =
  doAssert stack.head.value.integer, name
  doAssert stack.head.next.value.integer, name

proc integerOrFloat(name: string) {.inline.} =
  doAssert stack.head.value.floatable, name

proc integerOrFloatAsSecond(name: string) {.inline.} =
  doAssert stack.head.next.value.floatable, name

proc logical(name: string) {.inline.} =
  doAssert stack.head.value.logical, name

proc logicalAsSecond(name: string) {.inline.} =
  doAssert stack.head.next.value.logical, name

proc ordinal(name: string) {.inline.} =
  doAssert stack.head.value.ordinal, name

proc aggregate(name: string) {.inline.} =
  doAssert stack.head.value.aggregate, name

proc aggregateAsSecond(name: string) {.inline.} =
  doAssert stack.head.next.value.aggregate

proc oneQuote(name: string) {.inline.} =
  doAssert stack.head.value.list, name

template unary(op: untyped, name: string) =
  let x = pop()
  push(op(x))

template binary(op: untyped, name: string) =
  let y = pop()
  let x = pop()
  push(op(x, y))

template unfloatop(op: untyped, name: string) =
  oneParameter(name)
  integerOrFloat(name)
  unary(op, name)

template bifloatop(op: untyped, name: string) =
  twoParameters(name)
  integerOrFloat(name)
  integerOrFloatAsSecond(name)
  binary(op, name)

template bilogicop(op: untyped, name: string) =
  twoParameters(name)
  logical(name)
  logicalAsSecond(name)
  binary(op, name)

proc opId() {.inline.} = discard

proc opDup(name: auto) {.inline.} = 
  oneParameter(name)
  push(peek().clone)

# X Y  ->  Y X
proc opSwap(name: auto) {.inline.} =
  twoParameters(name)
  let y = pop()
  let x = pop()
  push(y)
  push(x)

# X Y Z  ->  Z X Y
proc opRollup(name: auto) {.inline.} =
  threeParameters(name)
  let z = pop()
  let y = pop()
  let x = pop()
  push(z)
  push(x)
  push(y)

# X Y Z  ->  Y Z X
proc opRolldown(name: auto) {.inline.} =
  threeParameters(name)
  let z = pop()
  let y = pop()
  let x = pop()
  push(y)
  push(z)
  push(x)

# X Y Z  ->  Z Y X
proc opRotate(name: auto) {.inline.} =
  threeParameters(name)
  let z = pop()
  let y = pop()
  let x = pop()
  push(z)
  push(y)
  push(x)

proc opPop(name: auto): Value {.inline.} =
  oneParameter(name)
  pop() 

proc opChoice(name: auto) {.inline.} =
  threeParameters(name)
  let f = pop()
  let t = pop()
  let b = pop()
  if isThruthy(b):
    push(t)
  else:
    push(f)

proc opCmp(name: auto) {.inline.} =
  let y = pop()
  let x = pop()
  push(cmp(x, y))

proc opOr(name: auto) {.inline.} = bilogicop(`or`, name)
proc opXor(name: auto) {.inline.} = bilogicop(`xor`, name)
proc opAnd(name: auto) {.inline.} = bilogicop(`and`, name)

proc opNot(name: auto) {.inline.} =
  oneParameter(name)
  logical(name)
  unary(`not`, name) 
  
proc opAdd(name: auto) {.inline.} = bifloatop(`+`, name)
proc opSub(name: auto) {.inline.} = bifloatop(`-`, name)
proc opMul(name: auto) {.inline.} = bifloatop(`*`, name)
proc opDivf(name: auto) {.inline.} = bifloatop(`/`, name)

proc opRem(name: auto) {.inline.} = bifloatop(`mod`, name)

proc opDiv(name: auto) {.inline.} =
  twoParameters(name)
  twoIntegers(name)
  let j = popt[IntVal]()
  let i = popt[IntVal]()
  let (k, l) = `div`(i, j)
  push(k)
  push(l)

proc opSign(name: auto) {.inline.} = unfloatop(sign, name)
proc opNeg(name: auto) {.inline.} = unfloatop(sign, name)

template unordop(op: untyped, name: auto) =
  oneParameter(name)
  ordinal(name)
  let x = pop()
  push(op(x))

proc opOrd(name: auto) {.inline.} = unordop(ord, name)
proc opChr(name: auto) {.inline.} = unordop(chr, name)

proc opAbs(name: auto) {.inline.} = unfloatop(abs, name)

proc opMin(name: auto) {.inline.} = bifloatop(min, name)
proc opMax(name: auto) {.inline.} = bifloatop(max, name)

proc opSqrt(name: auto) {.inline.} = unfloatop(sqrt, name)
proc opSin(name: auto) {.inline.} = unfloatop(sin, name)
proc opCos(name: auto) {.inline.} = unfloatop(cos, name)
proc opTan(name: auto) {.inline.} = unfloatop(tan, name)
proc opAsin(name: auto) {.inline.} = unfloatop(asin, name)
proc opAcos(name: auto) {.inline.} = unfloatop(acos, name)
proc opAtan(name: auto) {.inline.} = unfloatop(atan, name)
proc opSinh(name: auto) {.inline.} = unfloatop(sinh, name)
proc opCosh(name: auto) {.inline.} = unfloatop(cosh, name)
proc opTanh(name: auto) {.inline.} = unfloatop(tanh, name)

proc opPred(name: auto) {.inline.} = unordop(pred, name)
proc opSucc(name: auto) {.inline.} = unordop(succ, name)

proc opPut(name: auto) {.inline.} =
  oneParameter(name)
  let x = pop()
  echo x

proc opPeek(name: string) {.inline.} =
  oneParameter(name)

proc opCons(name: auto) {.inline.} =
  twoParameters(name)
  aggregate(name)
  binary(cons, name)
  
proc opSwons(name: auto) {.inline.} =
  opSwap(name)
  opCons(name)

proc opFirst(name: auto) {.inline.} =
  oneParameter(name)
  aggregate(name)
  let a = pop()
  push(first(a))

proc opRest(name: auto) {.inline.} =
  oneParameter(name)
  aggregate(name)
  let a = pop()
  push(rest(a))

template indexop(name: auto) =
  let i = popt[IntVal]()
  let a = pop()
  push(at(a, i))

proc opAt(name: auto) {.inline.} =
  twoParameters(name)
  integer(name)
  aggregateAsSecond(name)
  indexop(name)

proc opOf(name: auto) {.inline.} =
  twoParameters(name)
  aggregate(name)
  integerAsSecond(name)
  opSwap(name)
  indexop(name)

proc opSize(name: auto) {.inline.} =
  oneParameter(name)
  aggregate(name)
  let a = pop()
  push(size(a))

proc popuncons(name: auto): (Value, Value) {.inline.} =
  oneParameter(name)
  aggregate(name)
  let a = pop()
  uncons(a)

proc opUncons(name: auto) {.inline.} =
  let (first, rest) = popuncons(name)
  push(first)
  push(rest)

proc opUnswons(name: auto) {.inline.} =
  let (first, rest) = popuncons(name)
  push(rest)
  push(first)

proc opI(name: auto) {.inline.} =
  oneParameter(name)
  oneQuote(name)
  let p = popt[ListVal]()
  execterm(p)

proc opX(name: auto) {.inline.} =
  oneParameter(name)
  oneQuote(name)
  let p = peekt[ListVal]()
  execterm(p)

proc opDip(name: auto) {.inline.} =
  twoParameters(name)
  oneQuote(name)
  let p = popt[ListVal]()
  let x = pop()
  execterm(p)
  push(x)

proc opApp1(name: auto) {.inline.} =
  twoParameters(name)
  oneQuote(name)
  let p = popt[ListVal]()
  discard pop()
  execterm(p)

template nary(paramcount: untyped, name: auto, top: untyped) =
  paramcount(name)
  oneQuote(name)
  saved = stack
  let p = popt[ListVal]()
  execterm(p)
  let x = peek()
  stack.head = top
  stack.prepend(x)

proc opNullary(name: auto) {.inline.} = nary(oneParameter, name, saved2)
proc opUnary(name: auto) {.inline.} = nary(twoParameters, name, saved3)
proc opBinary(name: auto) {.inline.} = nary(threeParameters, name, saved4)
proc opTernary(name: auto) {.inline.} = nary(fourParameters, name, saved5)

proc opUnary2(name: auto) =
  threeParameters(name)
  oneQuote(name)
  saved = stack
  let p = popt[ListVal]()
  stack.head = saved2
  execterm(p)
  let py = peek()
  stack.head = saved3
  execterm(p)
  let px = peek()
  stack.head = saved4
  push(px)
  push(py)

proc opUnary3(name: auto) =
  fourParameters(name)
  oneQuote(name)
  saved = stack
  let p = popt[ListVal]()
  stack.head = saved2
  execterm(p)
  let pz = peek()
  stack.head = saved3
  execterm(p)
  let py = peek()
  stack.head = saved4
  execterm(p)
  let px = peek()
  stack.head = saved5
  push(px)
  push(py)
  push(pz)

proc opUnary4(name: auto) =
  fiveParameters(name)
  oneQuote(name)
  saved = stack
  let p = popt[ListVal]()
  stack.head = saved2
  execterm(p)
  let pw = peek()
  stack.head = saved3
  execterm(p)
  let pz = peek()
  stack.head = saved4
  execterm(p)
  let py = peek()
  stack.head = saved5
  execterm(p)
  let px = peek()
  stack.head = saved6
  push(px)
  push(py)
  push(pz)
  push(pw)

method eval*(x: Value) {.base.} =
  push(x)

method eval*(x: IdentVal) =
  case x.value
  of ID: opId()
  of DUP: opDup(DUP)
  of SWAP: opSwap(SWAP)
  of ROLLUP: opRollup(ROLLUP)
  of ROLLDOWN: opRolldown(ROLLDOWN)
  of ROTATE: opRotate(ROTATE)
  of POP: discard opPop(POP)
  of CHOICE: opChoice(CHOICE)
  of CMP: opCmp(CMP)
  of OR: opOr(OR)
  of XOR: opXor(XOR)
  of AND: opAnd(AND)
  of NOT: opNot(NOT)
  of ADD: opAdd(ADD)
  of SUB: opSub(SUB)
  of MUL: opMul(MUL)
  of DIVF: opDivf(DIVF)
  of REM: opRem(REM)
  of DIV: opDiv(DIV)
  of SIGN: opSign(SIGN)
  of NEG: opNeg(NEG)
  of ORD: opOrd(ORD)
  of CHR: opChr(CHR)
  of ABS: opAbs(ABS)
  of ACOS: opAcos(ACOS)
  of ASIN: opAsin(ASIN)
  of ATAN: opAtan(ATAN)
  of COS: opCos(COS)
  of COSH: opCosh(COSH)
  of SIN: opSin(SIN)
  of SINH: opSinh(SINH)
  of SQRT: opSqrt(SQRT)
  of TAN: opTan(TAN)
  of TANH: opTanh(TANH)
  of PRED: opPred(PRED)
  of SUCC: opSucc(SUCC)
  of MAX: opMax(MAX)
  of MIN: opMin(MIN)
  of PEEK: opPeek(PEEK)
  of PUT: opPut(PUT)
  of CONS: opCons(CONS)
  of SWONS: opSwons(SWONS)
  of FIRST: opFirst(FIRST)
  of REST: opRest(REST)
  of AT: opAt(AT)
  of OF: opOf(OF)
  of SIZE: opSize(SIZE)
  of UNCONS: opUncons(UNCONS)
  of UNSWONS: opUnswons(UNSWONS)
  of I: opI(I)
  of X: opX(X)
  of DIP: opDip(DIP)
  of APP1: opApp1(APP1)
  of NULLARY: opNullary(NULLARY)
  of UNARY: opUnary(UNARY)
  of BINARY: opBinary(BINARY)
  of TERNARY: opTernary(TERNARY)
  of UNARY2: opUnary2(UNARY2)
  of UNARY3: opUnary3(UNARY3)
  of UNARY4: opUnary4(UNARY4)
  else:
    let msg = "undefined symbol `" & $x & "`"
    raiseRuntimeError(msg)