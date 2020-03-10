import lists, vm

var stack* = initSinglyLinkedList[Value]()

proc push*(x: Value) =
  let node = newSinglyLinkedNode(x)
  stack.prepend(node)

proc pop*(): Value =
  result = stack.head.value
  stack.head = stack.head.next

proc add() =
  let y = pop()
  let x = pop()
  push(x + y)

proc sub() =
  let y = pop()
  let x = pop()
  push(x - y)

proc puts() =
  let x = pop()
  echo x

method eval*(x: Value) {.base.} = 
  push(x)

method eval*(x: IdentVal) =
  case x.value
  of "+": add()
  of "-": sub()
  of "puts": puts()
  else: discard