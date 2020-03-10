import lists, runtime

const ADD = "+"
const SUB = "-"
const MUL = "*"
const DIV = "/"
const MIN = "min"
const MAX = "max"
const NOT = "not"
const NEG = "neg"
const SQRT = "sqrt"
const SIN = "sin"
const ASIN = "asin"
const SINH = "sinh"
const COS = "cos"
const ACOS = "acos"
const COSH = "cosh"
const TAN = "tan"
const ATAN = "atan"
const TANH = "tanh"
const POP = "pop"
const PUTS = "puts"
const I = "i"
const X = "x" 

var stack* = initSinglyLinkedList[Value]()

method eval*(x: Value) {.base.}

proc exeterm(p: ListVal) =
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

method logical(x: Value): bool {.base,inline.} = false
method logical(x: BoolVal): bool {.inline.} = true

method list(x: Value): bool {.base,inline.} = false
method list(x: ListVal): bool {.inline.} = true

proc oneParameter(name: string) {.inline.} =
  doAssert stack.head != nil, name

proc twoParameters(name: string) {.inline.} =
  oneParameter(name)
  doAssert stack.head.next != nil, name

proc integerOrFloat(name: string) {.inline.} =
  doAssert stack.head.value.floatable, name

proc integerOrFloatAsSecond(name: string) {.inline.} =
  doAssert stack.head.next.value.floatable, name

proc logical(name: string) {.inline.} =
  doAssert stack.head.value.logical, name

proc quote(name: string) =
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

proc opAdd(name: auto) {.inline.} = bifloatop(`+`, name)
proc opSub(name: auto) {.inline.} = bifloatop(`-`, name)
proc opMul(name: auto) {.inline.} = bifloatop(`*`, name)
proc opDiv(name: auto) {.inline.} = bifloatop(`/`, name)

proc opMin(name: auto) {.inline.} = bifloatop(`min`, name)
proc opMax(name: auto) {.inline.} = bifloatop(`max`, name)

proc opSqrt(name: auto) {.inline.} = unfloatop(`sqrt`, name)
proc opSin(name: auto) {.inline.} = unfloatop(`sin`, name)
proc opCos(name: auto) {.inline.} = unfloatop(`cos`, name)
proc opTan(name: auto) {.inline.} = unfloatop(`tan`, name)
proc opAsin(name: auto) {.inline.} = unfloatop(`asin`, name)
proc opAcos(name: auto) {.inline.} = unfloatop(`acos`, name)
proc opAtan(name: auto) {.inline.} = unfloatop(`atan`, name)
proc opSinh(name: auto) {.inline.} = unfloatop(`sinh`, name)
proc opCosh(name: auto) {.inline.} = unfloatop(`cosh`, name)
proc opTanh(name: auto) {.inline.} = unfloatop(`tanh`, name)

proc opNot(name: auto) {.inline.} =
  oneParameter(name)
  logical(name)
  unary(`not`, name)

proc opNeg(name: auto) {.inline.} =
  integerOrFloat(name)
  unary(`neg`, name)

proc opPop*(name: auto): Value {.inline.} =
  oneParameter(name)
  pop()

proc opPuts(name: auto) {.inline.} =
  oneParameter(name)
  let x = pop()
  echo x

proc opI(name: auto) {.inline.} =
  oneParameter(name)
  quote(name)
  let p = popt[ListVal]()
  exeterm(p)

proc opX(name: auto) {.inline.} =
  oneParameter(name)
  quote(name)
  let p = peekt[ListVal]()
  exeterm(p)

method eval*(x: Value) {.base.} =
  push(x)

method eval*(x: IdentVal) =
  case x.value
  of ADD: opAdd(ADD)
  of SUB: opSub(SUB)
  of MUL: opMul(MUL)
  of DIV: opDiv(DIV)
  of MIN: opMin(MIN)
  of MAX: opMAX(MAX)
  of NOT: opNot(NOT)
  of NEG: opNeg(NEG)
  of SQRT: opSqrt(SQRT)
  of SIN: opSin(SIN)
  of COS: opCos(COS)
  of TAN: opTan(TAN)
  of ASIN: opAsin(ASIN)
  of ACOS: opAcos(ACOS)
  of ATAN: opAtan(ATAN)
  of SINH: opSinh(SINH)
  of COSH: opCosh(COSH)
  of TANH: opTanh(TANH)
  of PUTS: opPuts(PUTS)
  of I: opI(I)
  of X: opX(X)
  of POP: discard opPop(POP)
  else: discard