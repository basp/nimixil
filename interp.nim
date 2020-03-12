import lists, tables, runtime, strformat

type
  Op = ref object
    effect: string
    help: seq[string]
    fn: proc(name: string)

proc newOp(fn: proc(name: string)): Op = 
  Op(fn: fn)

proc newOp(
  fn: proc(name: string), 
  effect: string): Op = Op(fn: fn, effect: effect)

var
  stack* = initSinglyLinkedList[Value]()
  saved = initSinglyLinkedList[Value]()

method eval*(x: Value) {.base.}

template saved1 = saved.head
template saved2 = saved.head.next
template saved3 = saved.head.next.next
template saved4 = saved.head.next.next.next
template saved5 = saved.head.next.next.next.next

proc execTerm(p: List) =
  for x in p.val:
    eval(x)

proc push(x: Value) {.inline.} =
  let node = newSinglyLinkedNode(x)
  stack.prepend(node)

proc pop(): Value =
  result = stack.head.value
  stack.head = stack.head.next

proc peek(): Value {.inline.} = stack.head.value

method floatable(x: Value): bool {.base, inline.} = false
method floatable(x: Int): bool {.inline.} = true
method floatable(x: Float): bool {.inline.} = true

method integer(x: Value): bool {.base, inline.} = false
method integer(x: Int): bool {.inline.} = true

method logical(x: Value): bool {.base, inline.} = false
method logical(x: Bool): bool {.inline.} = true
method logical(x: Set): bool {.inline.} = true

method ordinal(x: Value): bool {.base, inline.} = false
method ordinal(x: Bool): bool {.inline.} = true
method ordinal(x: Int): bool {.inline.} = true
method ordinal(x: Char): bool {.inline.} = true

method aggregate(x: Value): bool {.base, inline.} = false
method aggregate(x: List): bool {.inline.} = true
method aggregate(x: Set): bool {.inline.} = true
method aggregate(x: String): bool {.inline.} = true

method list(x: Value): bool {.base, inline.} = false
method list(x: List): bool {.inline.} = true

proc raiseExecError(msg, name: string) =
  raiseRuntimeError(fmt"{msg} needed for `{name}`")

proc oneParameter(name: string) =
  const msg = "one parameter"
  if stack.head == nil:
    raiseExecError(msg, name)

proc twoParameters(name: string) =
  const msg = "two parameters"
  if stack.head == nil:
    raiseExecError(msg, name)
  if stack.head.next == nil:
    raiseExecError(msg, name)

proc threeParameters(name: string) =
  const msg = "three parameters"
  if stack.head == nil:
    raiseExecError(msg, name)
  if stack.head.next == nil:
    raiseExecError(msg, name)
  if stack.head.next.next == nil:
    raiseExecError(msg, name)

proc fourParameters(name: string) =
  const msg = "four parameters"
  if stack.head == nil:
    raiseExecError(msg, name)
  if stack.head.next == nil:
    raiseExecError(msg, name)
  if stack.head.next.next == nil:
    raiseExecError(msg, name)
  if stack.head.next.next.next == nil:
    raiseExecError(msg, name)

proc integerAsSecond(name: string) =
  const msg = "integer as second"
  if not integer(stack.head.next.value):
    raiseExecError(msg, name)

proc quoteOnTop(name: string) =
  const msg = "quotation on top"
  if not list(stack.head.value):
    raiseExecError(msg, name)

proc aggregateOnTop(name: string) =
  const msg = "aggregate on top"
  if not aggregate(stack.head.value):
    raiseExecError(msg, name)

proc aggregateAsSecond(name: string) =
  const msg = "aggregate as second parameter"
  if not aggregate(stack.head.next.value):
    raiseExecError(msg, name)

proc floatableOnTop(name: string) =
  const msg = "floatable on top"
  if not floatable(stack.head.value):
    raiseExecError(msg, name)

proc twoFloatables(name: string) =
  const msg = "two floatables"
  if not floatable(stack.head.value):
    raiseExecError(msg, name)
  if not floatable(stack.head.next.value):
    raiseExecError(msg, name)

template unOp(op: untyped, name: string) =
  let x = pop()
  push(op(x))

template biOp(op: untyped, name: string) =
  let y = pop()
  let x = pop()
  push(op(x, y))

template unFloatOp(op: untyped, name: string) =
  oneParameter(name)
  floatableOnTop(name)
  unOp(op, name)

template biFloatOp(op: untyped, name: string) =
  twoParameters(name)
  twoFloatables(name)
  biOp(op, name)

proc opId(name: auto) = discard

proc opDup(name: auto) = push(peek().clone)

proc opPop(name: auto)  =
  oneParameter(name)
  discard pop()

proc opAdd(name: auto) = biFloatOp(`+`, name)
proc opSub(name: auto) = biFloatOp(`-`, name)
proc opMul(name: auto) = biFloatOp(`*`, name)
proc opDiv(name: auto) = biFloatOp(`/`, name)

proc opSqrt(name: auto) = unFloatOp(sqrt, name)
proc opSin(name: auto) = unFloatOp(sin, name)
proc opCos(name: auto) = unFloatOp(cos, name)
proc opTan(name: auto) = unFloatOp(tan, name)
proc opAsin(name: auto) = unFloatOp(asin, name)
proc opAcos(name: auto) = unFloatOp(acos, name)
proc opAtan(name: auto) = unFloatOp(atan, name)
proc opSinh(name: auto) = unFloatOp(sinh, name)
proc opCosh(name: auto) = unFloatOp(cosh, name)
proc opTanh(name: auto) = unFloatOp(tanh, name)

proc opFirst(name: auto) =
  oneParameter(name)
  let a = pop()
  push(first(a))

proc opRest(name: auto) =
  oneParameter(name)
  let a = pop()
  push(rest(a))

proc opCons(name: auto) =
  twoParameters(name)
  aggregateOnTop(name)
  let a = pop()
  let x = pop()
  push(cons(x, a))

proc opSwap(name: auto) =
  twoParameters(name)
  let y = pop()
  let x = pop()
  push(y)
  push(x)

proc opMap(name: auto) =
  twoParameters(name)
  quoteOnTop(name)
  aggregateAsSecond(name)
  saved = stack
  let b = newList(@[])
  let p = cast[List](pop())
  let a = cast[List](pop())
  for x in a.val:
    push(x)
    execterm(p)
    b.val.append(pop())
    stack = saved
  stack.head = saved3
  push(b)

proc opTimes(name: auto) =
  twoParameters(name)
  quoteOnTop(name)
  integerAsSecond(name)
  let p = cast[List](pop())
  let n = cast[Int](pop())
  for t in 0..<n.val:
    execTerm(p)

var optable = initTable[string, Op]()
optable.add("id", newOp(opId, "the id function; does nothing"))
optable.add("dup", newOp(opDup))
optable.add("pop", newOp(opPop))
optable.add("+", newOp(opAdd))
optable.add("-", newOp(opSub))
optable.add("*", newOp(opMul))
optable.add("/", newOp(opDiv))
optable.add("sqrt", newOp(opSqrt))
optable.add("sin", newOp(opSin))
optable.add("cos", newOp(opCos))
optable.add("tan", newOp(opTan))
optable.add("asin", newOp(opAsin))
optable.add("acos", newOp(opAcos))
optable.add("atan", newOp(opAtan))
optable.add("sinh", newOp(opSinh))
optable.add("cosh", newOp(opCosh))
optable.add("tanh", newOp(opTanh))
optable.add("first", newOp(opFirst))
optable.add("rest", newOp(opRest))
optable.add("cons", newOp(opCons))
optable.add("swap", newOp(opSwap))
optable.add("map", newOp(opMap))
optable.add("times", newOp(opTimes))

method eval*(x: Value) {.base.} = push(x)

method eval*(x: Ident) =
  if optable.hasKey(x.val):
    optable[x.val].fn(x.val)
  else:
    let msg = fmt"undefined symbol `{x.val}`"
    raiseRuntimeError(msg)
