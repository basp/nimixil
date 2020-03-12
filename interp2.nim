import lists, tables, runtime2, strformat

type
  Op = ref object
    effect: string
    help: seq[string]
    fn: proc(name: string)

proc newOp(fn: proc(name: string)): Op = Op(fn: fn)

var optable = initTable[string, Op]()

var 
  stack* = initSinglyLinkedList[Value]()
  # saved = initSinglyLinkedList[Value]()

method eval*(x: Value) {.base.}

# proc execTerm(p: List) =
#   for x in p.val:
#     eval(x)

proc push(x: Value) {.inline.} =
  let node = newSinglyLinkedNode(x)
  stack.prepend(node)

proc pop(): Value {.inline.} =
  result = stack.head.value
  stack.head = stack.head.next

# proc peek(): Value {.inline.} = stack.head.value

method floatable(x: Value): bool {.base,inline.} = false
method floatable(x: Int): bool {.inline.} = true
method floatable(x: Float): bool {.inline.} = true

method integer(x: Value): bool {.base,inline.} = false
method integer(x: Int): bool {.inline.} = true

method logical(x: Value): bool {.base,inline.} = false
method logical(x: Bool): bool {.inline.} = true
method logical(x: Set): bool {.inline.} = true

method ordinal(x: Value): bool {.base,inline.} = false
method ordinal(x: Bool): bool {.inline.} = true
method ordinal(x: Int): bool {.inline.} = true
method ordinal(x: Char): bool {.inline.} = true

method aggregate(x: Value): bool {.base,inline.} = false
method aggregate(x: List): bool {.inline.} = true
method aggregate(x: Set): bool {.inline.} = true
method aggregate(x: String): bool {.inline.} = true

method list(x: Value): bool {.base,inline.} = false
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

# proc threeParameters(name: string) =
#   const msg = "three parameters"
#   if stack.head == nil:
#     raiseExecError(msg, name)
#   if stack.head.next == nil:
#     raiseExecError(msg, name)
#   if stack.head.next.next == nil:
#     raiseExecError(msg, name)

proc aggregateOnTop(name: string) =
  const msg = "aggregate on top"
  if not aggregate(stack.head.value):
    raiseExecError(msg, name)

proc opPop(name: auto) = 
  oneParameter(name)
  discard pop()

proc opAdd(name: auto) =
  twoParameters(name)
  let y = pop()
  let x = pop()
  push(x + y)

proc opSub(name: auto) =
  twoParameters(name)
  let y = pop()
  let x = pop()
  push(x - y)

proc opMul(name: auto) =
  twoParameters(name)
  let y = pop()
  let x = pop()
  push(x - y)

proc opDiv(name: auto) =
  twoParameters(name)
  let y = pop()
  let x = pop()
  push(x - y)

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

optable.add("pop", newOp(opPop))
optable.add("+", newOp(opAdd))
optable.add("-", newOp(opSub))
optable.add("*", newOp(opMul))
optable.add("/", newOp(opDiv))
optable.add("first", newOp(opFirst))
optable.add("rest", newOp(opRest))
optable.add("cons", newOp(opCons))
optable.add("swap", newOP(opSwap))

method eval*(x: Value) {.base.} = push(x)

method eval*(x: Ident)  =
  if optable.hasKey(x.val): 
    optable[x.val].fn(x.val)
  else:
    let msg = fmt"undefined symbol `{x.val}`"
    raiseRuntimeError(msg)