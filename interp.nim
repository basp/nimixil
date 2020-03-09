import lists, parse

var stack* = initSinglyLinkedList[Factor]()

proc push*(x: Factor) =
  let node = newSinglyLinkedNode(x)
  stack.prepend(node)

proc pop*[T]: T =
  result = stack.head.value
  stack.head = stack.head.next

proc add() =
  let y = pop[Factor]()
  let x = pop[Factor]()
  case x.op
  of opString:
    case y.op
    of opInt:
      push(initString(x.s & $y.i))
    of opFloat:
      push(initString(x.s & $y.f))
    of opString:
      push(initString(x.s & y.s))
    else:
      raise newException(Exception, "NOSUP")
  of opInt:
    case y.op
    of opInt:
      push(initInt(x.i + y.i))
    of opFloat:
      push(initFloat(float(x.i) + y.f))
    of opString:
      push(initString($x.i & y.s))
    else:
      raise newException(Exception, "NOSUP")
  of opFloat:
    case y.op:
    of opInt:
      push(initFloat(x.f + float(x.i)))
    of opFloat:
      push(initFloat(x.f + y.f))
    of opString:
      push(initString($x.f & y.s))
    else:
      raise newException(Exception, "NOSUP")
  else:
    raise newException(Exception, "NOSUP")

proc puts() =
  let x = pop[Factor]()
  case x.op
  of opInt: echo x.i
  of opFloat: echo x.f
  of opString: echo x.s
  else:
    raise newException(Exception, "NOSUP")

proc isDefined(id: string): bool =
  false

proc eval*(x: Factor) =
  case x.op:
  of opBool, opInt, opFloat, opString, opList:
    push(x)
  of opIdent:
    if x.id == "+":
      add()
      return
    elif x.id == "puts":
      puts()
      return
    elif isDefined(x.id):
      discard
    else:
      raise newException(Exception, "UNDEF")
  else:
    raise newException(Exception, "NOSUP")
