import strutils

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
  ListVal* = ref object of Value
    values*: seq[Value]
  SetVal* = ref object of Value

proc newBool*(x: bool): BoolVal =
  BoolVal(value: x)

proc newInt*(x: int): IntVal =
  IntVal(value: x)

proc newFloat*(x: float): Value =
  FloatVal(value: x)

proc newChar*(x: char): Value =
  CharVal(value: x)

proc newString*(x: string): Value =
  StringVal(value: x)

proc newIdent*(x: string): Value =
  IdentVal(value: x)

proc newList*(x: seq[Value]): Value =
  ListVal(values: x)

proc newValue*(v: int): IntVal =
  IntVal(value: v)

proc newValue*(v: float): FloatVal =
  FloatVal(value: v)

proc newValue*(v: string): StringVal =
  StringVal(value: v)

proc newValue*(v: bool): BoolVal =
  BoolVal(value: v)

method `$`*(self: Value): string {.base.} = 
  repr(self)

method `$`*(self: IntVal): string = 
  $self.value

method `$`*(self: FloatVal): string = 
  $self.value

method `$`*(self: BoolVal): string = 
  $self.value

method `$`*(self: StringVal): string = 
  escape(self.value)

method `$`*(self: IdentVal): string = 
  self.value

method `+`*(a: Value, b: Value): Value {.base.} =
  raise newException(Exception, "tilt")

method `+`*(a: IntVal, b: IntVal): Value =
  newInt(a.value + b.value)

method `+`*(a: IntVal, b: FloatVal): Value =
  newFloat(a.value.float + b.value)

method `+`*(a: FloatVal, b: IntVal): Value =
  newFloat(a.value + b.value.float)

method `+`*(a: FloatVal, b: FloatVal): Value =
  newFloat(a.value + b.value)

method `-`*(a: Value, b: Value): Value {.base.} =
  raise newException(Exception, "tilt")

method `-`*(a: IntVal, b: IntVal): Value =
  newInt(a.value - b.value)

method `-`*(a: IntVal, b: FloatVal): Value =
  newFloat(a.value.float - b.value)

method `-`*(a: FloatVal, b: IntVal): Value =
  newFloat(a.value - b.value.float)

method `-`*(a: FloatVal, b: FloatVal): Value =
  newFloat(a.value - b.value)

