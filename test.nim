import macros

# https://github.com/gokr/spryvm/blob/master/spryvm/spryvm.nim

type
  Value = ref object of RootObj
  IntVal* = ref object of Value
    value*: int
  FloatVal* = ref object of Value
    value*: float
  StringVal* = ref object of Value
    value*: string

