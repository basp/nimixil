import lists, sequtils, math

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

template literalEq(t: untyped) =
  method `==`*(a, b: t): bool = a.val == b.val

method cmp*(a: Value, b: Value): Int {.base, inline.} =
  raiseRuntimeError("TILT cmp")

# method cmp*(a: IntVal, b: IntVal): IntVal {.inline.} =
#   newInt(cmp(a.value, b.value))

method `==`*(a, b: Value): bool {.base.} = false

literalEq(Bool)
literalEq(Char)
literalEq(Int)
literalEq(Float)
literalEq(String)
literalEq(Set)
literalEq(Ident)

method `==`*(a, b: List): bool {.inline.} =
  var x = a.val.head
  var y = b.val.head
  while x != nil and y != nil:
    if x.value != y.value:
      return false
    x = x.next
    y = y.next
  true

proc add*(a: Set, x: int) =
  a.val = a.val or (1 shl x)

proc add*(a: Set, x: Int) =
  a.add(x.val)

proc add*(a: List, x: Value) =
  a.val.append(x)

proc contains*(a: Set, x: int): bool =
  (a.val and (1 shl x)) > 0

proc contains*(a: Set, x: Int): bool =
  a.contains(x.val)

proc contains*(a: List, x: Value): bool =
  a.val.contains(x)

iterator items*(a: String): char =
  for c in a.val:
    yield c

iterator items*(a: List): Value =
  var node = a.val.head
  while node != nil:
    yield node.value
    node = node.next

iterator items*(a: Set): int =
  for x in 0..<MaxSetSize:
    if a.contains(x):
      yield x

proc `[]`*(a: String, i: int): char = a[i]
proc `[]`*(a: Set, i: int): int = toSeq(a.items)[i]
proc `[]`*(a: List, i: int): Value = toSeq(a.items)[i]

template unFloatOp(op: untyped, fn: untyped) =
  method op*(a: Value): Value {.base.} =
    raiseRuntimeError("tilt")
  method op*(a: Int): Value  =
    newFloat(fn(a.val.float))
  method op*(a: Float): Value =
    newFloat(fn(a.val))

template biFloatOp(op: untyped, fn: untyped, ctor: untyped) =
  method op*(a: Value, b: Value): Value {.base.} =
    raiseRuntimeError("tilt")
  method op*(a: Int, b: Int): Value =
    ctor(fn(a.val, b.val))
  method op*(a: Int, b: Float): Value  =
    newFloat(fn(a.val.float, b.val))
  method op*(a: Float, b: Int): Value =
    newFloat(fn(a.val, b.val.float))
  method op*(a: Float, b: Float): Value =
    newFloat(fn(a.val, b.val))

unFloatOp(acos, arcsin)
unFloatOp(asin, arcsin)
unFloatOp(atan, arctan)
unFloatOp(cos, cos)
unFloatOp(sin, sin)
unFloatOp(tan, tan)
unFloatOp(cosh, cosh)
unFloatOp(sinh, sinh)
unFloatOp(tanh, tanh)
unFloatOp(exp, exp)
unFloatOp(sqrt, sqrt)

biFloatOp(`+`, `+`): newInt
biFloatOp(`-`, `+`): newInt
biFloatOp(`*`, `+`): newInt
biFloatOp(`/`, `/`): newFloat
biFloatOp(`rem`, `mod`): newInt

when isMainModule:
  echo rem(newInt(3), newInt(2)).repr
  echo rem(newFloat(0.5), newFloat(0.3)).repr