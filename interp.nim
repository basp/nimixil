import lists, parse

var stack* = initSinglyLinkedList[Factor]()

proc push*(x: Factor) =
  let node = newSinglyLinkedNode(x)
  stack.prepend(node)

proc pop*(): Factor =
  result = stack.head.value
  stack.head = stack.tail

proc eval*(x: Factor) =
  case x.op:
  of opBool, opInt, opFloat, opString, opList:
    push(x)
  of opIdent:
    raise newException(Exception, "TODO")
  else:
    raise newException(Exception, "FOO")
