import strutils, strformat, math, lists, sequtils

const SETSIZE = 32

type
  Value* = ref object of RootObj
  IntVal* = ref object of Value
    value*: int
  BoolVal* = ref object of Value
    value*: bool
  CharVal* = ref object of Value
    value*: char
  FloatVal* = ref object of Value
    value*: float
  StringVal* = ref object of Value
    value*: string
  IdentVal* = ref object of Value
    value*: string
  SetVal* = ref object of Value
    value*: int
  ListVal* = ref object of Value
    elements*: SinglyLinkedList[Value]
  RuntimeError* = object of Exception

proc raiseRuntimeError*(msg: string) =
  raise newException(RuntimeError, msg)

method isThruthy*(x: Value): bool {.base, inline.} = false
method isThruthy*(x: IntVal): bool {.inline.} = x.value != 0
method isThruthy*(x: FloatVal): bool {.inline.} = x.value != 0
method isThruthy*(x: StringVal): bool {.inline.} = len(x.value) > 0
method isThruthy*(x: BoolVal): bool {.inline.} = x.value
method isThruthy*(x: ListVal): bool {.inline.} = x.elements.head != nil
method isThruthy*(x: SetVal): bool {.inline.} = x.value > 0
method isThruthy*(x: CharVal): bool {.inline.} = ord(x.value) > 0

proc add*(s: int, x: range[0..SETSIZE-1]): int =
  s or (1 shl x)

proc remove*(s: int, x: range[0..SETSIZE-1]): int =
  s and not (1 shl x)

proc contains*(s: int, x: range[0..SETSIZE-1]): bool =
  (s and (1 shl x)) > 0

iterator items*(s: int): int =
  for i in 0..<SETSIZE:
    if s.contains(i):
      yield i

proc newBool*(x: bool): BoolVal {.inline.} =
  BoolVal(value: x)

proc newInt*(x: int): IntVal {.inline.} =
  IntVal(value: x)

proc newFloat*(x: float): Value {.inline.} =
  FloatVal(value: x)

proc newChar*(x: char): Value {.inline.} =
  CharVal(value: x)

proc newString*(x: string): Value {.inline.} =
  StringVal(value: x)

proc newIdent*(x: string): Value {.inline.} =
  IdentVal(value: x)

proc newSet*(x: int): Value {.inline.} =
  SetVal(value: x)

proc newList*(xs: seq[Value]): ListVal {.inline.} =
  var list = initSinglyLinkedList[Value]()
  for x in xs: list.append(x)
  ListVal(elements: list)

proc newList*(xs: SomeLinkedList[Value]): Value {.inline.} =
  ListVal(elements: xs)

proc newValue*(v: int): IntVal {.inline.} =
  IntVal(value: v)

proc newValue*(v: float): FloatVal {.inline.} =
  FloatVal(value: v)

proc newValue*(v: string): StringVal {.inline.} =
  StringVal(value: v)

proc newValue*(v: bool): BoolVal {.inline.} =
  BoolVal(value: v)

method clone*(self: Value): Value {.base, inline.} =
  self
method clone*(self: IntVal): Value {.inline.} =
  newInt(self.value)
method clone*(self: BoolVal): Value {.inline.} =
  newBool(self.value)
method clone*(self: CharVal): Value {.inline.} =
  newChar(self.value)
method clone*(self: FloatVal): Value {.inline.} =
  newFloat(self.value)
method clone*(self: StringVal): Value {.inline.} =
  newString(self.value)
method clone*(self: IdentVal): Value {.inline.} =
  newIdent(self.value)
method clone*(self: SetVal): Value {.inline.} =
  newSet(self.value)

method `$`*(self: Value): string {.base, inline.} =
  repr(self)
method `$`*(self: IntVal): string {.inline.} =
  $self.value
method `$`*(self: CharVal): string {.inline.} =
  repr(self.value)
method `$`*(self: BoolVal): string {.inline.} =
  $self.value
method `$`*(self: FloatVal): string {.inline.} =
  $self.value
method `$`*(self: StringVal): string {.inline.} =
  escape(self.value)
method `$`*(self: IdentVal): string {.inline.} =
  self.value
method `$`*(self: ListVal): string {.inline.} =
  $self.elements
method `$`*(self: SetVal): string {.inline.} =
  var xs = toSeq(items(self.value))
  "{" & strutils.join(xs, " ") & "}"

proc badarg(name: string, x: Value) =
  let msg = fmt"badarg: {name} does not support argument {x}"
  raiseRuntimeError(msg)

method `==`*(a: Value, b: Value): bool {.base, inline.} = false
method `==`*(a: IntVal, b: IntVal): bool {.inline.} =
  a.value == b.value
method `==`*(a: IntVal, b: FloatVal): bool {.inline.} =
  a.value.float == b.value
method `==`*(a: FloatVal, b: IntVal): bool {.inline.} =
  a.value == b.value.float
method `==`*(a: FloatVal, b: FloatVal): bool {.inline.} =
  a.value == b.value
method `==`*(a: BoolVal, b: BoolVal): bool {.inline.} =
  a.value == b.value
method `==`*(a: CharVal, b: CharVal): bool {.inline.} =
  a.value == b.value
method `==`*(a: StringVal, b: StringVal): bool {.inline.} =
  a.value == b.value
method `==`*(a: SetVal, b: SetVal): bool {.inline.} =
  a.value == b.value
method `==`*(a: ListVal, b: ListVal): bool {.inline.} =
  var x = a.elements.head
  var y = b.elements.head
  while x != nil and y != nil:
    if x.value != y.value:
      return false
    x = x.next
    y = y.next
  true

proc `!=`*(a: Value, b: Value): bool = not (a == b)

method `or`*(a: Value, b: Value): Value {.base, inline.} =
  raiseRuntimeError("TILT or")
method `or`*(a: BoolVal, b: BoolVal): Value {.inline.} =
  newBool(a.value or b.value)
method `or`*(a: SetVal, b: SetVal): Value {.inline.} =
  newSet(a.value or b.value)

method `xor`*(a: Value, b: Value): Value {.base, inline.} =
  raiseRuntimeError("TILT or")
method `xor`*(a: BoolVal, b: BoolVal): Value {.inline.} =
  newBool(a.value xor b.value)
method `xor`*(a: SetVal, b: SetVal): Value {.inline.} =
  newSet(a.value xor b.value)

method `and`*(a: Value, b: Value): Value {.base, inline.} =
  raiseRuntimeError("TILT and")
method `and`*(a: BoolVal, b: BoolVal): Value {.inline.} =
  newBool(a.value and b.value)
method `and`*(a: SetVal, b: SetVal): Value {.inline.} =
  newSet(a.value and b.value)

method `not`*(a: Value): Value {.base, inline.} =
  badarg("not", a)
method `not`*(a: BoolVal): Value {.inline.} =
  newBool(not a.value)
method `not`*(a: Setval): Value {.inline.} =
  newSet(not a.value)

method `+`*(a: Value, b: Value): Value {.base, inline.} =
  raiseRuntimeError("TILT +")
method `+`*(a: IntVal, b: IntVal): Value {.inline.} =
  newInt(a.value + b.value)
method `+`*(a: IntVal, b: FloatVal): Value {.inline.} =
  newFloat(a.value.float + b.value)
method `+`*(a: FloatVal, b: IntVal): Value {.inline.} =
  newFloat(a.value + b.value.float)
method `+`*(a: FloatVal, b: FloatVal): Value {.inline.} =
  newFloat(a.value + b.value)

method `-`*(a: Value, b: Value): Value {.base, inline.} =
  raiseRuntimeError("TILT -")
method `-`*(a: IntVal, b: IntVal): Value {.inline.} =
  newInt(a.value - b.value)
method `-`*(a: IntVal, b: FloatVal): Value {.inline.} =
  newFloat(a.value.float - b.value)
method `-`*(a: FloatVal, b: IntVal): Value {.inline.} =
  newFloat(a.value - b.value.float)
method `-`*(a: FloatVal, b: FloatVal): Value {.inline.} =
  newFloat(a.value - b.value)

method `*`*(a: Value, b: Value): Value {.base.} =
  raiseRuntimeError("TILT *")
method `*`*(a: IntVal, b: IntVal): Value {.inline.} =
  newInt(a.value * b.value)
method `*`*(a: IntVal, b: FloatVal): Value {.inline.} =
  newFloat(a.value.float * b.value)
method `*`*(a: FloatVal, b: IntVal): Value {.inline.} =
  newFloat(a.value * b.value.float)
method `*`*(a: FloatVal, b: FloatVal): Value {.inline.} =
  newFloat(a.value * b.value)

method `/`*(a: Value, b: Value): Value {.base, inline.} =
  raiseRuntimeError("TILT /")
method `/`*(a: IntVal, b: IntVal): Value {.inline.} =
  newFloat(a.value / b.value)
method `/`*(a: IntVal, b: FloatVal): Value {.inline.} =
  newFloat(a.value.float / b.value)
method `/`*(a: FloatVal, b: IntVal): Value {.inline.} =
  newFloat(a.value / b.value.float)
method `/`*(a: FloatVal, b: FloatVal): Value {.inline.} =
  newFloat(a.value / b.value)

method `mod`*(a: Value, b: Value): Value {.base, inline.} =
  raiseRuntimeError("TILT mod")
method `mod`*(a: IntVal, b: IntVal): Value {.inline.} =
  newInt(a.value mod b.value)
method `mod`*(a: IntVal, b: FloatVal): Value {.inline.} =
  newFloat(a.value.float mod b.value)
method `mod`*(a: FloatVal, b: IntVal): Value {.inline.} =
  newFloat(a.value mod b.value.float)
method `mod`*(a: FloatVal, b: FloatVal): Value {.inline.} =
  newFloat(a.value mod b.value)

method `div`*(a: Value, b: Value): (Value, Value) {.base, inline.} =
  raiseRuntimeError("TILT div")
method `div`*(a: IntVal, b: IntVal): (Value, Value) {.inline.} =
  let q = a.value div b.value
  let rem = a.value mod b.value
  (newInt(q), newInt(rem))

method sign*(a: Value): Value {.base, inline.} =
  raiseRuntimeError("TILT sign")
method sign*(a: IntVal): Value {.inline.} =
  newInt(sgn[int](a.value))
method sign*(a: FloatVal): Value {.inline.} =
  newfloat(sgn[float](a.value).float)

method neg*(a: Value): Value {.base, inline.} =
  raiseRuntimeError("TILT neg")
method neg*(a: IntVal): Value {.inline.} =
  newInt(-a.value)
method neg*(a: FloatVal): Value {.inline.} =
  newFloat(-a.value)

method ord*(a: Value): IntVal {.base, inline.} =
  raiseRuntimeError("TILT ord")
method ord*(a: CharVal): IntVal {.inline.} =
  newInt(ord(a.value))
method ord*(a: IntVal): IntVal {.inline.} =
  newInt(ord(a.value))
method ord*(a: BoolVal): IntVal {.inline.} =
  newInt(ord(a.value))

method chr*(a: Value): Value {.base, inline.} =
  raiseRuntimeError("TILT chr")
method chr*(a: CharVal): Value {.inline.} =
  newChar(chr(ord(a.value)))
method chr*(a: IntVal): Value {.inline.} =
  newChar(chr(a.value))
method chr*(a: BoolVal): Value {.inline.} =
  newChar(chr(ord(a.value)))

method abs*(a: Value): Value {.base, inline.} =
  raiseRuntimeError("TILT abs")
method abs*(a: IntVal): Value {.inline.} =
  newInt(abs(a.value))
method abs*(a: FloatVal): Value {.inline.} =
  newFloat(abs(a.value))

method acos*(a: Value): Value {.base, inline.} =
  raiseRuntimeError("TILT acos")
method acos*(a: IntVal): Value {.inline.} =
  newFloat(arccos(a.value.float))
method acos*(a: FloatVal): Value {.inline.} =
  newFloat(arccos(a.value.float))

method asin*(a: Value): Value {.base, inline.} =
  raiseRuntimeError("TILT asin")
method asin*(a: IntVal): Value {.inline.} =
  newFloat(arcsin(a.value.float))
method asin*(a: FloatVal): Value {.inline.} =
  newFloat(arcsin(a.value.float))

method atan*(a: Value): Value {.base, inline.} =
  raiseRuntimeError("TILT atan")
method atan*(a: IntVal): Value {.inline.} =
  newFloat(arctan(a.value.float))
method atan*(a: FloatVal): Value {.inline.} =
  newFloat(arctan(a.value.float))

method atan2*(a: Value, b: Value): Value {.base, inline.} =
  raiseRuntimeError("TILT atan2")

method ceil*(a: Value): Value {.base, inline.} =
  raiseRuntimeError("TILT ceil")

method cos*(a: Value): Value {.base, inline.} =
  raiseRuntimeError("TILT cos")
method cos*(a: IntVal): Value {.inline.} =
  newFloat(cos(a.value.float))
method cos*(a: FloatVal): Value {.inline.} =
  newFloat(cos(a.value))

method cosh*(a: Value): Value {.base, inline.} =
  raiseRuntimeError("TILT cosh")

method exp*(a: Value): Value {.base, inline.} =
  raiseRuntimeError("TILT exp")

method floor*(a: Value): Value {.base, inline.} =
  raiseRuntimeError("TILT floor")

method sin*(a: Value): Value {.base, inline.} =
  raiseRuntimeError("TILT sin")
method sin*(a: IntVal): Value {.inline.} =
  newFloat(sin(a.value.float))
method sin*(a: FloatVal): Value {.inline.} =
  newFloat(sin(a.value))

method sinh*(a: Value): Value {.base.} =
  raiseRuntimeError("TILT sinh")

method sqrt*(a: Value): Value {.base, inline.} =
  raiseRuntimeError("TILT sqrt")
method sqrt*(a: IntVal): Value {.inline.} =
  newFloat(sqrt(a.value.float))
method sqrt*(a: FloatVal): Value {.inline.} =
  newFloat(sqrt(a.value))

method tan*(a: Value): Value {.base.} =
  raiseRuntimeError("TILT tan")
method tan*(a: IntVal): Value {.inline.} =
  newFloat(tan(a.value.float))
method tan*(a: FloatVal): Value {.inline.} =
  newFloat(tan(a.value))

method tanh*(a: Value): Value {.base.} =
  raiseRuntimeError("TILT tanh")

method pred*(a: Value): Value {.base, inline.} =
  raiseRuntimeError("TILT pred")
method pred*(a: BoolVal): Value {.inline.} =
  newBool(pred(a.value))
method pred*(a: CharVal): Value {.inline.} =
  newChar(pred(a.value))
method pred*(a: IntVal): Value {.inline.} =
  newInt(pred(a.value))

method succ*(a: Value): Value {.base, inline.} =
  raiseRuntimeError("TILT succ")
method succ*(a: BoolVal): Value {.inline.} =
  newBool(succ(a.value))
method succ*(a: CharVal): Value {.inline.} =
  newChar(succ(a.value))
method succ*(a: IntVal): Value {.inline.} =
  newInt(succ(a.value))

method max*(a: Value, b: Value): Value {.base, inline.} =
  raiseRuntimeError("TILT max")
method max*(a: IntVal, b: IntVal): Value {.inline.} =
  newInt(max(a.value, b.value))
method max*(a: FloatVal, b: IntVal): Value {.inline.} =
  newFloat(max(a.value, b.value.float))
method max*(a: IntVal, b: FloatVal): Value {.inline.} =
  newFloat(max(a.value.float, b.value))
method max*(a: FloatVal, b: FloatVal): Value {.inline.} =
  newFloat(max(a.value, b.value))

method min*(a: Value, b: Value): Value {.base, inline.} =
  raiseRuntimeError("TILT min")
method min*(a: IntVal, b: IntVal): Value {.inline.} =
  newInt(min(a.value, b.value))
method min*(a: FloatVal, b: IntVal): Value {.inline.} =
  newFloat(min(a.value, b.value.float))
method min*(a: IntVal, b: FloatVal): Value {.inline.} =
  newFloat(min(a.value.float, b.value))
method min*(a: FloatVal, b: FloatVal): Value {.inline.} =
  newFloat(min(a.value, b.value))

method cons*(x: Value, a: Value): Value {.base, inline.} =
  raiseRuntimeError("TILT cons")
method cons*(x: Value, a: ListVal): Value {.inline.} =
  var xs = a.elements
  xs.append(x)
  newList(xs)
method cons*(x: CharVal, a: StringVal): Value {.inline.} =
  var str = a.value
  str.insert($x.value)
  newString(str)
method cons*(x: IntVal, a: SetVal): Value {.inline.} =
  let s = add(a.value, x.value)
  newSet(s)

method first*(a: Value): Value {.base, inline.} =
  raiseRuntimeError("TILT first")
method first*(a: ListVal): Value {.inline.} =
  a.elements.head.value.clone
method first*(a: SetVal): Value {.inline.} =
  newInt(toSeq(items(a.value))[0])
method first*(a: StringVal): Value {.inline.} =
  newChar(a.value[0])

method rest*(a: Value): Value {.base, inline.} =
  raiseRuntimeError("TILT rest")
method rest*(a: ListVal): Value {.inline.} =
  var list = initSinglyLinkedList[Value]()
  list.head = a.elements.head.next
  newList(list)
method rest*(a: SetVal): Value {.inline.} =
  let first = toSeq(items(a.value))[0]
  newSet(remove(a.value, first))

method at*(a: Value, i: IntVal): Value {.base, inline.} =
  raiseRuntimeError("TILT cons")
method at*(a: ListVal, i: IntVal): Value {.inline.} =
  toSeq(a.elements.items)[i.value]
method at*(a: SetVal, i: IntVal): Value {.inline.} =
  newInt(toSeq(items(a.value))[i.value])
method at*(a: StringVal, i: IntVal): Value {.inline.} =
  newChar(a.value[i.value])

method size*(a: Value): IntVal {.base, inline.} =
  raiseRuntimeError("TILT size")
method size*(a: ListVal): IntVal {.inline.} =
  newInt(toSeq(a.elements.items).len)
method size*(a: SetVal): IntVal {.inline.} =
  newInt(toSeq(items(a.value)).len)
method size*(a: StringVal): IntVal {.inline.} =
  newInt(a.value.len)

proc uncons*(a: Value): (Value, Value) {.inline.} =
  (first(a), rest(a))

method zero*(x: Value): bool {.base, inline.} = false
method zero*(x: IntVal): bool {.inline.} = x.value == 0
method zero*(x: FloatVal): bool {.inline.} = x.value == 0
method zero*(x: BoolVal): bool {.inline.} = ord(x.value) == 0
method zero*(x: CharVal): bool {.inline.} = ord(x.value) == 0

method one*(x: Value): bool {.base, inline.} = false
method one*(x: IntVal): bool {.inline.} = x.value == 1
method one*(x: FloatVal): bool {.inline.} = x.value == 1
method one*(x: BoolVal): bool {.inline.} = ord(x.value) == 1
method one*(x: CharVal): bool {.inline.} = ord(x.value) == 1

method null*(x: Value): BoolVal {.base, inline.} =
  newBool(false)
method null*(x: ListVal): BoolVal {.inline.} =
  newBool(size(x).value == 0)
method null*(x: SetVal): BoolVal {.inline.} =
  newBool(size(x).value == 0)
method null*(x: StringVal): BoolVal {.inline.} =
  newBool(size(x).value == 0)
method null*(x: IntVal): BoolVal {.inline.} =
  newBool(zero(x))
method null*(x: FloatVal): BoolVal {.inline.} =
  newBool(zero(x))
method null*(x: BoolVal): BoolVal {.inline.} =
  newBool(zero(x))

method small*(x: Value): BoolVal {.base, inline.} =
  newBool(false)
method small*(x: IntVal): BoolVal {.inline.} =
  newBool(zero(x) or one(x))
method small*(x: FloatVal): BoolVal {.inline.} =
  newBool(zero(x) or one(x))
method small*(x: BoolVal): BoolVal {.inline.} =
  newBool(zero(x) or one(x))
method small*(x: CharVal): BoolVal {.inline.} =
  newBool(zero(x) or one(x))
method small*(x: StringVal): BoolVal {.inline.} =
  newBool(size(x).value < 2)
method small*(x: ListVal): BoolVal {.inline.} =
  newBool(size(x).value < 2)
method small*(x: SetVal): BoolVal {.inline.} =
  newBool(size(x).value < 2)

method cmp*(a: Value, b: Value): IntVal {.base, inline.} =
  raiseRuntimeError("TILT cmp")
method cmp*(a: IntVal, b: IntVal): IntVal {.inline.} =
  newInt(cmp(a.value, b.value))
method cmp*(a: IntVal, b: FloatVal): IntVal {.inline.} =
  newInt(cmp(a.value.float, b.value))
method cmp*(a: FloatVal, b: IntVal): IntVal {.inline.} =
  newInt(cmp(a.value, b.value.float))
method cmp*(a: BoolVal, b: BoolVal): IntVal {.inline.} =
  newInt(cmp(a.value, b.value))
method cmp*(a: BoolVal, b: IntVal): IntVal {.inline.} =
  newInt(cmp(ord(a.value), b.value))
method cmp*(a: IntVal, b: BoolVal): IntVal {.inline.} =
  newInt(cmp(a.value, ord(b.value)))
method cmp*(a: BoolVal, b: CharVal): IntVal {.inline.} =
  newInt(cmp(ord(a.value), ord(b.value)))
method cmp*(a: CharVal, b: BoolVal): IntVal {.inline.} =
  newInt(cmp(ord(a.value), ord(b.value)))
method cmp*(a: CharVal, b: CharVal): IntVal {.inline.} =
  newInt(cmp(a.value, b.value))
method cmp*(a: CharVal, b: IntVal): IntVal {.inline.} =
  newInt(cmp(ord(a.value), b.value))
method cmp*(a: IntVal, b: CharVal): IntVal {.inline.} =
  newInt(cmp(a.value, ord(b.value)))
method cmp*(a: SetVal, b: SetVal): IntVal {.inline.} =
  newInt(cmp(a.value, b.value))
method cmp*(a: StringVal, b: StringVal): IntVal {.inline.} =
  newInt(cmp(a.value, b.value))
method cmp*(a: ListVal, b: ListVal): IntVal {.inline.} =
  if a.size > b.size:
    return newInt(1)
  if a.size < b.size:
    return newInt(-1)
  for (x, y) in zip(toSeq(a.elements.items), toSeq(b.elements.items)):
    let z = cmp(x, y)
    if not zero(z): return z
  return newInt(0)