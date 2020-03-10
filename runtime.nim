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

method `$`*(self: Value): string {.base, inline.} =
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

method `+`*(a: Value, b: Value): Value {.base, inline.} =
  raise newException(Exception, "TILT +")
method `+`*(a: IntVal, b: IntVal): Value {.inline.} =
  newInt(a.value + b.value)
method `+`*(a: IntVal, b: FloatVal): Value {.inline.} =
  newFloat(a.value.float + b.value)
method `+`*(a: FloatVal, b: IntVal): Value {.inline.} =
  newFloat(a.value + b.value.float)
method `+`*(a: FloatVal, b: FloatVal): Value {.inline.} =
  newFloat(a.value + b.value)

method `-`*(a: Value, b: Value): Value {.base, inline.} =
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

method `/`*(a: Value, b: Value): Value {.base, inline.} =
  raise newException(Exception, "TILT /")
method `/`*(a: IntVal, b: IntVal): Value {.inline.} =
  newFloat(a.value / b.value)
method `/`*(a: IntVal, b: FloatVal): Value {.inline.} =
  newFloat(a.value.float / b.value)
method `/`*(a: FloatVal, b: IntVal): Value {.inline.} =
  newFloat(a.value / b.value.float)
method `/`*(a: FloatVal, b: FloatVal): Value {.inline.} =
  newFloat(a.value / b.value)

method `not`*(a: Value): Value {.base, inline.} =
  raise newException(Exception, "TILT not")
method `not`*(a: BoolVal): Value {.inline.} =
  newBool(not a.value)

method `neg`*(a: Value): Value {.base, inline.} =
  raise newException(Exception, "TILT neg")
method `neg`*(a: IntVal): Value {.inline.} =
  newInt(-a.value)
method `neg`*(a: FloatVal): Value {.inline.} =
  newFloat(-a.value)

method `sqrt`*(a: Value): Value {.base, inline.} =
  raise newException(Exception, "TILT sqrt")
method `sqrt`*(a: IntVal): Value {.inline.} =
  newFloat(sqrt(a.value.float))
method `sqrt`*(a: FloatVal): Value {.inline.} =
  newFloat(sqrt(a.value))

method `sin`*(a: Value): Value {.base, inline.} =
  raise newException(Exception, "TILT sin")
method `sin`*(a: IntVal): Value {.inline.} =
  newFloat(sin(a.value.float))
method `sin`*(a: FloatVal): Value {.inline.} =
  newFloat(sin(a.value))

method `cos`*(a: Value): Value {.base, inline.} =
  raise newException(Exception, "TILT cos")
method `cos`*(a: IntVal): Value {.inline.} =
  newFloat(cos(a.value.float))
method `cos`*(a: FloatVal): Value {.inline.} =
  newFloat(cos(a.value))

method `tan`*(a: Value): Value {.base.} =
  raise newException(Exception, "TILT tan")
method `tan`*(a: IntVal): Value {.inline.} =
  newFloat(tan(a.value.float))
method `tan`*(a: FloatVal): Value {.inline.} =
  newFloat(tan(a.value))

method `asin`*(a: Value): Value {.base, inline.} =
  raise newException(Exception, "TILT asin")
method `asin`*(a: IntVal): Value {.inline.} =
  newFloat(arcsin(a.value.float))
method `asin`*(a: FloatVal): Value {.inline.} =
  newFloat(arcsin(a.value.float))

method `acos`*(a: Value): Value {.base, inline.} =
  raise newException(Exception, "TILT acos")
method `acos`*(a: IntVal): Value {.inline.} =
  newFloat(arccos(a.value.float))
method `acos`*(a: FloatVal): Value {.inline.} =
  newFloat(arccos(a.value.float))

method `atan`*(a: Value): Value {.base, inline.} =
  raise newException(Exception, "TILT atan")
method `atan`*(a: IntVal): Value {.inline.} =
  newFloat(arctan(a.value.float))
method `atan`*(a: FloatVal): Value {.inline.} =
  newFloat(arctan(a.value.float))

method `sinh`*(a: Value): Value {.base.} =
  raise newException(Exception, "TILT sinh")

method `cosh`*(a: Value): Value {.base.} =
  raise newException(Exception, "TILT cosh")

method `tanh`*(a: Value): Value {.base.} =
  raise newException(Exception, "TILT tanh")


