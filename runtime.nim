import strutils, math

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
    value: int
  ListVal* = ref object of Value
    elements*: seq[Value]

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

proc newList*(x: seq[Value]): Value {.inline.} =
  ListVal(elements: x)

proc newValue*(v: int): IntVal {.inline.} =
  IntVal(value: v)

proc newValue*(v: float): FloatVal {.inline.} =
  FloatVal(value: v)

proc newValue*(v: string): StringVal {.inline.} =
  StringVal(value: v)

proc newValue*(v: bool): BoolVal {.inline.} =
  BoolVal(value: v)

method clone*(self: Value): Value {.base,inline.} =
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

method `$`*(self: Value): string {.base,inline.} =
  repr(self)
method `$`*(self: IntVal): string {.inline.} =
  $self.value
method `$`*(self: FloatVal): string {.inline.} =
  $self.value
method `$`*(self: BoolVal): string {.inline.} =
  $self.value
method `$`*(self: StringVal): string {.inline.} =
  escape(self.value)
method `$`*(self: IdentVal): string {.inline.} =
  self.value
method `$`*(self: CharVal): string {.inline.} =
  repr(self.value)

method `or`*(a: Value, b: Value): Value {.base,inline.} =
  raise newException(Exception, "TILT or")
method `or`*(a: BoolVal, b: BoolVal): Value {.inline.} =
  newBool(a.value or b.value)
method `or`*(a: SetVal, b: SetVal): Value {.inline.} =
  newSet(a.value or b.value)

method `xor`*(a: Value, b: Value): Value {.base,inline.} =
  raise newException(Exception, "TILT or")
method `xor`*(a: BoolVal, b: BoolVal): Value {.inline.} =
  newBool(a.value xor b.value)
method `xor`*(a: SetVal, b: SetVal): Value {.inline.} =
  newSet(a.value xor b.value)

method `and`*(a: Value, b: Value): Value {.base,inline.} =
  raise newException(Exception, "TILT and")
method `and`*(a: BoolVal, b: BoolVal): Value {.inline.} =
  newBool(a.value and b.value)
method `and`*(a: SetVal, b: SetVal): Value {.inline.} =
  newSet(a.value and b.value)

method `not`*(a: Value): Value {.base,inline.} =
  raise newException(Exception, "TILT not")
method `not`*(a: BoolVal): Value {.inline.} =
  newBool(not a.value)
method `not`*(a: Setval): Value {.inline.} =
  newSet(not a.value)

method `+`*(a: Value, b: Value): Value {.base,inline.} =
  raise newException(Exception, "TILT +")
method `+`*(a: IntVal, b: IntVal): Value {.inline.} =
  newInt(a.value + b.value)
method `+`*(a: IntVal, b: FloatVal): Value {.inline.} =
  newFloat(a.value.float + b.value)
method `+`*(a: FloatVal, b: IntVal): Value {.inline.} =
  newFloat(a.value + b.value.float)
method `+`*(a: FloatVal, b: FloatVal): Value {.inline.} =
  newFloat(a.value + b.value)

method `-`*(a: Value, b: Value): Value {.base,inline.} =
  raise newException(Exception, "TILT -")
method `-`*(a: IntVal, b: IntVal): Value {.inline.} =
  newInt(a.value - b.value)
method `-`*(a: IntVal, b: FloatVal): Value {.inline.} =
  newFloat(a.value.float - b.value)
method `-`*(a: FloatVal, b: IntVal): Value {.inline.} =
  newFloat(a.value - b.value.float)
method `-`*(a: FloatVal, b: FloatVal): Value {.inline.} =
  newFloat(a.value - b.value)

method `*`*(a: Value, b: Value): Value {.base.} =
  raise newException(Exception, "TILT *")
method `*`*(a: IntVal, b: IntVal): Value {.inline.} =
  newInt(a.value * b.value)
method `*`*(a: IntVal, b: FloatVal): Value {.inline.} =
  newFloat(a.value.float * b.value)
method `*`*(a: FloatVal, b: IntVal): Value {.inline.} =
  newFloat(a.value * b.value.float)
method `*`*(a: FloatVal, b: FloatVal): Value {.inline.} =
  newFloat(a.value * b.value)

method `/`*(a: Value, b: Value): Value {.base,inline.} =
  raise newException(Exception, "TILT /")
method `/`*(a: IntVal, b: IntVal): Value {.inline.} =
  newFloat(a.value / b.value)
method `/`*(a: IntVal, b: FloatVal): Value {.inline.} =
  newFloat(a.value.float / b.value)
method `/`*(a: FloatVal, b: IntVal): Value {.inline.} =
  newFloat(a.value / b.value.float)
method `/`*(a: FloatVal, b: FloatVal): Value {.inline.} =
  newFloat(a.value / b.value)

method `mod`*(a: Value, b: Value): Value {.base,inline.} =
  raise newException(Exception, "TILT mod")
method `mod`*(a: IntVal, b: IntVal): Value {.inline.} =
  newInt(a.value mod b.value)  
method `mod`*(a: IntVal, b: FloatVal): Value {.inline.} =
  newFloat(a.value.float mod b.value)  
method `mod`*(a: FloatVal, b: IntVal): Value {.inline.} =
  newFloat(a.value mod b.value.float)  
method `mod`*(a: FloatVal, b: FloatVal): Value {.inline.} =
  newFloat(a.value mod b.value)  

method `div`*(a: Value, b: Value): (Value, Value) {.base,inline.} =
  raise newException(Exception, "TILT div")
method `div`*(a: IntVal, b: IntVal): (Value, Value) {.inline.} =
  let q = a.value div b.value
  let rem = a.value mod b.value
  (newInt(q), newInt(rem))

method sign*(a: Value): Value {.base,inline.} =
  raise newException(Exception, "TILT sign")
method sign*(a: IntVal): Value {.inline.} =
  newInt(sgn[int](a.value))
method sign*(a: FloatVal): Value {.inline.} =
  newfloat(sgn[float](a.value).float)

method neg*(a: Value): Value {.base,inline.} =
  raise newException(Exception, "TILT neg")
method neg*(a: IntVal): Value {.inline.} =
  newInt(-a.value)
method neg*(a: FloatVal): Value {.inline.} =
  newFloat(-a.value)

method ord*(a: Value): Value {.base,inline.} =
  raise newException(Exception, "TILT ord")
method ord*(a: CharVal): Value {.inline.} =
  newInt(ord(a.value))
method ord*(a: IntVal): Value {.inline.} =
  newInt(ord(a.value))
method ord*(a: BoolVal): Value {.inline.} =
  newInt(ord(a.value))

method chr*(a: Value): Value {.base,inline.} =
  raise newException(Exception, "TILT chr")
method chr*(a: CharVal): Value {.inline.} =
  newChar(chr(ord(a.value)))
method chr*(a: IntVal): Value {.inline.} =
  newChar(chr(a.value))
method chr*(a: BoolVal): Value {.inline.} =
  newChar(chr(ord(a.value)))

method abs*(a: Value): Value {.base,inline.} =
  raise newException(Exception, "TILT abs")
method abs*(a: IntVal): Value {.inline.} =
  newInt(abs(a.value))
method abs*(a: FloatVal): Value {.inline.} =
  newFloat(abs(a.value))

method acos*(a: Value): Value {.base, inline.} =
  raise newException(Exception, "TILT acos")
method acos*(a: IntVal): Value {.inline.} =
  newFloat(arccos(a.value.float))
method acos*(a: FloatVal): Value {.inline.} =
  newFloat(arccos(a.value.float))

method asin*(a: Value): Value {.base,inline.} =
  raise newException(Exception, "TILT asin")
method asin*(a: IntVal): Value {.inline.} =
  newFloat(arcsin(a.value.float))
method asin*(a: FloatVal): Value {.inline.} =
  newFloat(arcsin(a.value.float))

method atan*(a: Value): Value {.base,inline.} =
  raise newException(Exception, "TILT atan")
method atan*(a: IntVal): Value {.inline.} =
  newFloat(arctan(a.value.float))
method atan*(a: FloatVal): Value {.inline.} =
  newFloat(arctan(a.value.float))

method atan2*(a: Value, b: Value): Value {.base,inline.} =
  raise newException(Exception, "TILT atan2")

method ceil*(a: Value): Value {.base,inline.} =
  raise newException(Exception, "TILT ceil")

method cos*(a: Value): Value {.base, inline.} =
  raise newException(Exception, "TILT cos")
method cos*(a: IntVal): Value {.inline.} =
  newFloat(cos(a.value.float))
method cos*(a: FloatVal): Value {.inline.} =
  newFloat(cos(a.value))

method cosh*(a: Value): Value {.base,inline.} =
  raise newException(Exception, "TILT cosh")

method exp*(a: Value): Value {.base,inline.} =
  raise newException(Exception, "TILT exp")

method floor*(a: Value): Value {.base,inline.} =
  raise newException(Exception, "TILT floor")

method sin*(a: Value): Value {.base, inline.} =
  raise newException(Exception, "TILT sin")
method sin*(a: IntVal): Value {.inline.} =
  newFloat(sin(a.value.float))
method sin*(a: FloatVal): Value {.inline.} =
  newFloat(sin(a.value))

method sinh*(a: Value): Value {.base.} =
  raise newException(Exception, "TILT sinh")

method sqrt*(a: Value): Value {.base, inline.} =
  raise newException(Exception, "TILT sqrt")
method sqrt*(a: IntVal): Value {.inline.} =
  newFloat(sqrt(a.value.float))
method sqrt*(a: FloatVal): Value {.inline.} =
  newFloat(sqrt(a.value))

method tan*(a: Value): Value {.base.} =
  raise newException(Exception, "TILT tan")
method tan*(a: IntVal): Value {.inline.} =
  newFloat(tan(a.value.float))
method tan*(a: FloatVal): Value {.inline.} =
  newFloat(tan(a.value))

method tanh*(a: Value): Value {.base.} =
  raise newException(Exception, "TILT tanh")

method max*(a: Value, b: Value): Value {.base,inline.} =
  raise newException(Exception, "TILT max")
method max*(a: IntVal, b: IntVal): Value {.inline.} =
  newInt(max(a.value, b.value))
method max*(a: FloatVal, b: IntVal): Value {.inline.} =
  newFloat(max(a.value, b.value.float))
method max*(a: IntVal, b: FloatVal): Value {.inline.} =
  newFloat(max(a.value.float, b.value))
method max*(a: FloatVal, b: FloatVal): Value {.inline.} =
  newFloat(max(a.value, b.value))

method min*(a: Value, b: Value): Value {.base,inline.} =
  raise newException(Exception, "TILT min")
method min*(a: IntVal, b: IntVal): Value {.inline.} =
  newInt(min(a.value, b.value))
method min*(a: FloatVal, b: IntVal): Value {.inline.} =
  newFloat(min(a.value, b.value.float))
method min*(a: IntVal, b: FloatVal): Value {.inline.} =
  newFloat(min(a.value.float, b.value))
method min*(a: FloatVal, b: FloatVal): Value {.inline.} =
  newFloat(min(a.value, b.value))

method cons*(x: Value, a: Value): Value {.base,inline.} =
  raise newException(Exception, "TILT cons")
method cons*(x: Value, a: ListVal): Value {.inline.} =
  var xs = a.elements
  xs.insert(x)
  newList(xs)