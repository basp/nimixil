import lists, vm

var stack* = initSinglyLinkedList[Value]()

template oneParameter(name: string) =
  doAssert stack.head != nil, name

template twoParameters(name: string) =
  oneParameter(name)
  doAssert stack.head.next != nil, name

method floatable(x: Value): bool {.base,inline.} = false
method floatable(x: IntVal): bool {.inline.} = true
method floatable(x: FloatVal): bool {.inline.} = true

template integerOrFloat(name: string) =
  doAssert stack.head.value.floatable, name

template integerOrFloatAsSecond(name: string) =
  doAssert stack.head.next.value.floatable, name

proc push(x: Value) {.inline.} =
  let node = newSinglyLinkedNode(x)
  stack.prepend(node)

proc pop(): Value {.inline} =
  result = stack.head.value
  stack.head = stack.head.next

template unary(op: untyped, name: string) =
  let x = pop()
  push(op(x))

template binary(op: untyped, name: string) =
  let y = pop()
  let x = pop()
  push(op(x, y))

template binfloatop(op: untyped, name: string) =
  twoParameters(name)
  integerOrFloat(name)
  integerOrFloatAsSecond(name)
  binary(op, name)

proc opAdd() {.inline.} = binfloatop(`+`, "+")
proc opSub() {.inline.} = binfloatop(`-`, "-")
proc opMul() {.inline.} = binfloatop(`*`, "*")
proc opDiv() {.inline.} = binfloatop(`/`, "/")

proc opPop*(): Value {.inline.} =
  oneParameter("pop")
  pop()

proc opPuts() {.inline.} =
  oneParameter("puts")
  let x = pop()
  echo x

method eval*(x: Value) {.base.} =
  push(x)

method eval*(x: IdentVal) =
  case x.value
  of "+": opAdd()
  of "-": opSub()
  of "*": opMul()
  of "/": opDiv()
  of "not":
    unary(`not`, "not")
  of "neg":
    unary(`neg`, "neg")
  of "pop": discard opPop()
  of "puts": opPuts()
  else: discard
