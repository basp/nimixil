import lists, sequtils, math, strformat, strutils

const MaxSetSize = 32

type
  Value* = ref object of RootObj
  Bool* = ref object of Value
    val*: bool
  Char* = ref object of Value
    val*: char
  Int* = ref object of Value
    val*: int
  Float* = ref object of Value
    val*: float
  String* = ref object of Value
    val*: string
  Set* = ref object of Value
    val*: int
  List* = ref object of Value
    val*: SinglyLinkedList[Value]
  Ident* = ref object of Value
    val*: string
  Usr* = ref object
    id*: string
    term*: seq[Value]
  RuntimeError* = object of Exception

proc raiseRuntimeError*(msg: string) =
  raise newException(RuntimeError, msg)

proc newBool*(val: bool): Bool =
  Bool(val: val)

proc newChar*(val: char): Char =
  Char(val: val)

proc newInt*(val: int): Int =
  Int(val: val)

proc newFloat*(val: float): Float =
  Float(val: val)

proc newString*(val: string): String =
  String(val: val)

proc newSet*(val: int): Set =
  Set(val: val)

proc newList*(): List =
  List(val: initSinglyLinkedList[Value]())

proc newList*(xs: seq[Value]): List =
  result = newList()
  for x in xs: result.val.append(x)

proc newList*(xs: SomeLinkedList[Value]): Value =
  List(val: xs)

proc newIdent*(val: string): Ident =
  Ident(val: val)

method `==`*(a, b: Value): bool {.base.} = false

template literalEq(t: untyped) =
  method `==`*(a, b: t): bool = a.val == b.val

literalEq(Bool)
literalEq(Char)
literalEq(Int)
literalEq(Float)
literalEq(String)
literalEq(Set)
literalEq(Ident)

proc add*(a: Set, x: int) =
  a.val = a.val or (1 shl x)

proc add*(a: Set, x: Int) =
  a.add(x.val)

proc add*(a: List, x: Value) =
  a.val.append(x)

proc delete*(a: Set, x: int) =
  a.val = a.val and not (1 shl x)

proc contains*(a: Set, x: int): bool =
  (a.val and (1 shl x)) > 0

proc contains*(a: Set, x: Int): bool =
  a.contains(x.val)

proc contains*(a: List, x: Value): bool =
  a.val.contains(x)

iterator items*(a: String): char =
  for c in a.val:
    yield c

iterator items*(a: Set): int =
  for x in 0..<MaxSetSize:
    if a.contains(x):
      yield x

iterator items*(a: List): Value =
  var node = a.val.head
  while node != nil:
    yield node.value
    node = node.next

proc `[]`*(a: String, i: int): char = a[i]
proc `[]`*(a: Set, i: int): int = toSeq(a.items)[i]
proc `[]`*(a: List, i: int): Value = toSeq(a.items)[i]

method `$`*(a: Value): string {.base} = repr(a)

template literalStr(t: untyped) =
  method `$`*(a: t): string = $a.val

literalStr(Bool)
literalStr(Int)
literalStr(Float)
literalStr(List)

method `$`*(a: Char): string = repr(a.val)
method `$`*(a: String): string = escape(a.val)
method `$`*(a: Set): string = "{" & join(toSeq(items(a)), " ") & "}"

method `==`*(a, b: List): bool =
  var x = a.val.head
  var y = b.val.head
  while x != nil and y != nil:
    if x.value != y.value:
      return false
    x = x.next
    y = y.next
  true

template unFloatOp(name: string, op: untyped, fn: untyped) =
  method op*(a: Value): Value {.base.} =
    raiseRuntimeError("badarg for `" & name & "`")
  method op*(a: Int): Value  =
    newFloat(fn(a.val.float))
  method op*(a: Float): Value =
    newFloat(fn(a.val))

template biFloatOp(name: string, op: untyped, fn: untyped, ctor: untyped) =
  method op*(a: Value, b: Value): Value {.base.} =
    raiseRuntimeError("badargs for `" & name & "`")
  method op*(a: Int, b: Int): Value =
    ctor(fn(a.val, b.val))
  method op*(a: Int, b: Float): Value  =
    newFloat(fn(a.val.float, b.val))
  method op*(a: Float, b: Int): Value =
    newFloat(fn(a.val, b.val.float))
  method op*(a: Float, b: Float): Value =
    newFloat(fn(a.val, b.val))

template biLogicOp(name: string, op: untyped) =
  method op*(a: Value, b: Value): Value {.base.} =
    raiseRuntimeError("badargs for `" & name & "`")
  method op*(a: Bool, b: Bool): Value =
    newBool(op(a.val, b.val))
  method op*(a: Set, b: Set): Value =
    newSet(op(a.val, b.val))

unFloatOp("acos", acos, arcsin)
unFloatOp("asin", asin, arcsin)
unFloatOp("atan", atan, arctan)
unFloatOp("cos", cos, cos)
unFloatOp("sin", sin, sin)
unFloatOp("tan", tan, tan)
unFloatOp("cosh", cosh, cosh)
unFloatOp("sinh", sinh, sinh)
unFloatOp("tanh", tanh, tanh)
unFloatOp("exp", exp, exp)
unFloatOp("sqrt", sqrt, sqrt)

biFloatOp("+", `+`, `+`): newInt
biFloatOp("-", `-`, `-`): newInt
biFloatOp("*", `*`, `+`): newInt
biFloatOp("/", `/`, `/`): newFloat
biFloatOp("rem", `rem`, `mod`): newInt

biLogicOp("and", `and`)
biLogicOp("or", `or`)
biLogicOp("xor", `xor`)

method first*(a: Value): Value {.base.} = 
  raiseRuntimeError("badarg for `first`")
method first*(a: String): Value = 
  newChar(a[0])
method first*(a: Set): Value =
  newInt(toSeq(items(a))[0])
method first*(a: List): Value =
  toSeq(items(a))[0]

method rest*(a: Value): Value {.base.} =
  raiseRuntimeError("badarg for `rest`")
method rest*(a: List): Value =
  var list = initSinglyLinkedList[Value]()
  list.head = a.val.head.next
  newList(list)
method rest*(a: Set): Value =
  let first = toSeq(items(a))[0]
  a.delete(first)
  a
