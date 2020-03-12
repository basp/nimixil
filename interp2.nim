import lists, tables, runtime2, strformat

type
  Op = ref object
    effect: string
    help: seq[string]
    fn: proc()

proc newOp(fn: proc()): Op = Op(fn: fn)

var optable = initTable[string, Op]()

var 
  stack* = initSinglyLinkedList[Value]()
  saved = initSinglyLinkedList[Value]()

method eval*(x: Value) {.base.}

proc execTerm(p: List) =
  for x in p.val:
    eval(x)

proc push(x: Value) {.inline.} =
  let node = newSinglyLinkedNode(x)
  stack.prepend(node)

proc pop(): Value {.inline.} =
  result = stack.head.value
  stack.head = stack.head.next

proc peek(): Value {.inline.} = stack.head.value

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

proc opPop() = 
  oneParameter("pop")
  discard pop()

proc opAdd() =
  twoParameters("add")
  let y = pop()
  let x = pop()
  push(x + y)

proc opSub() =
  twoParameters("sub")
  let y = pop()
  let x = pop()
  push(x - y)

proc opFirst() =
  oneParameter("first")
  let a = pop()
  push(first(a))

proc opRest() =
  oneParameter("rest")
  let a = pop()
  push(rest(a))

proc opCons() =
  twoParameters("cons")
  let a = pop()
  let x = pop()
  push(cons(x, a))

optable.add("pop", newOp(opPop))
optable.add("+", newOp(opAdd))
optable.add("-", newOp(opSub))
optable.add("first", newOp(opFirst))
optable.add("rest", newOp(opRest))

method eval*(x: Value) {.base.} = push(x)

method eval*(x: Ident)  =
  if optable.hasKey(x.val): 
    optable[x.val].fn()
  else:
    let msg = fmt"undefined symbol `{x.val}`"
    raiseRuntimeError(msg)