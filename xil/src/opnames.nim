const 
  NEWSTACK* = "newstack"
  STACK* = "stack"
  UNSTACK* = "unstack"

  # operators
  ID* = "id"
  DUP* = "dup"
  SWAP* = "swap"
  ROLLUP* = "rollup"
  ROLLDOWN* = "rolldown"
  ROTATE* = "rotate"
  POPD* = "popd"
  DUPD* = "dupd"
  SWAPD* = "swapd"
  ROLLUPD* = "rollupd"
  ROLLDOWND* = "rolldownd"
  ROTATED* = "rotated"
  POP* = "pop"
  PEEK* = "peek"
  PUT* = "put"
  GET* = "get"
  CHOICE* = "choice"
  CMP* = "cmp"
  OR* = "or"
  XOR* = "xor"
  AND* = "and"
  NOT* = "not"
  ADD* = "+"
  SUB* = "-"
  MUL* = "*"
  DIVIDE* = "/"
  REM* = "rem"
  DIV* = "div"
  SIGN* = "sign"
  NEG* = "neg"
  ORD* = "ord"
  CHR* = "chr"
  ABS* = "abs"
  ACOS* = "acos"
  ASIN* = "asin"
  ATAN* = "atan"
  CEIL* = "ceil"
  COS* = "cos"
  COSH* = "cosh"
  EXP* = "exp"
  FLOOR* = "floor"
  SIN* = "sin"
  SINH* = "sinh"
  SQRT* = "sqrt"
  TAN* = "tan"
  TANH* = "tanh"
  TRUNC* = "trunc"
  PRED* = "pred"
  SUCC* = "succ"
  MAX* = "max"
  MIN* = "min"
  CONS* = "cons"
  SWONS* = "swons"
  FIRST* = "first"
  REST* = "rest"
  AT* = "at"
  OF* = "of"
  SIZE* = "size"
  OPCASE* = "opcase"
  CASE* = "case"
  UNCONS* = "uncons"
  UNSWONS* = "unswons"
  DROP* = "drop"
  TAKE* = "take"
  CONCAT* = "concat"
  ENCONCAT* = "enconcat"
  REVERSE* = "reverse"
  NAME* = "name"
  INTERN* = "intern"
  BODY* = "body"
  
  # predicates
  NULL* = "null"
  SMALL* = "small"
  GT* = ">"
  LT* = "<"
  GTE* = ">="
  LTE* = "<="
  EQ* = "="
  NEQ* = "!="
  INTEGER* = "integer"
  FLOAT* = "float"
  CHAR* = "char"
  LOGICAL* = "logical"
  SET* = "set"
  STRING* = "string"
  LIST* = "list"
  LEAF* = "leaf"
  USER* = "user"

  # combinators
  I* = "i"
  X* = "x" 
  DIP* = "dip"
  APP1* = "app1"
  NULLARY* = "nullary"
  UNARY* = "unary"
  UNARY2* = "unary2"
  UNARY3* = "unary3"
  UNARY4* = "unary4"
  BINARY* = "binary"
  TERNARY* = "ternary"
  CLEAVE* = "cleave"
  BRANCH* = "branch"
  IFTE* = "ifte"
  IFINTEGER* = "ifinteger"
  IFCHAR* = "ifchar"
  IFLOGICAL* = "iflogical"
  IFSET* = "ifset"
  IFSTRING* ="ifstring"
  IFLIST* = "iflist"
  IFFLOAT* = "iffloat"
  COND* = "cond"
  WHILE* = "while"
  LINREC* = "linrec"
  TAILREC* = "tailrec"
  BINREC* = "binrec"
  GENREC* = "genrec"
  CONDLINREC* = "condlinrec"
  STEP* = "step"
  FOLD* = "fold"
  MAP* = "map"
  TIMES* = "times"
  INFRA* = "infra"
  PRIMREC* = "primrec"
  FILTER* = "filter"
  SPLIT* = "split"
  SOME* = "some"
  ALL* = "all"
  TREESTEP* = "treestep"
  TREEREC* = "treerec"

  # misc
  HELP* = "help"
  HELPDETAIL* = "helpdetail"
  QUIT* = "quit"