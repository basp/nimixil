import lists, tables, runtime2, strformat

type
  Op = ref object
    effect: string
    help: seq[string]
    fn: proc()

proc newOp(fn: proc()): Op = Op(fn: fn)

let optable = initTable[string, Op]()

var 
  stack = initSinglyLinkedList[Value]()
  saved = initSinglyLinkedList[Value]()

# method eval*(x: Value) {.base,locks:0.}

# proc execterm(p: ListVal) =
#   for x in p.elements:
#     eval(x)

proc push(x: Value) {.inline.} =
  let node = newSinglyLinkedNode(x)
  stack.prepend(node)

proc pop(): Value {.inline.} =
  result = stack.head.value
  stack.head = stack.head.next

proc peek(): Value {.inline.} = stack.head.value

proc raiseExecError(msg, name: string) =
  raiseRuntimeError(fmt"{msg} needed for `{name}`")

proc opPop() = discard pop()
proc opPeek() = 

method eval*(x: Value) {.base.} = push(x)