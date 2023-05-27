const defaultCapacity = 256

type
  StringBuilder* = ref object
    len: int
    cap: int
    string: string
    grow: Grow

  Grow* = proc(sb: StringBuilder, needed: int): int

# doubles capacity generator, this is the default strategy
proc doubling*(sb: StringBuilder, needed: int): int {.procvar.} =
  let newCapacity = sb.cap * 2
  if newCapacity < needed: needed + defaultCapacity else: newCapacity

# creates a linear growth strategy, which will cause the stringbuilder to
# grow to the desired amount + the specified amount
proc linear*(amount: int): Grow =
  return proc(sb: StringBuilder, needed: int): int = needed + amount

# gets the capacity (this is the length + extra space for future growth)
proc capacity*(sb: StringBuilder): int {.inline, noSideEffect.} =
  sb.cap

# gets the length of the string
proc len*(sb: StringBuilder): int {.inline, noSideEffect.} =
  sb.len

# creates a new string from the stringbuilder, see destroy for an efficient alternative
proc `$`*(sb: StringBuilder): string {.inline.} =
  substr(sb.string, 0, sb.len)

# efficiently converts the stringbuilder into a string.
# using any stringbuilder method after a call to destry (including additional
# calls to destroy) will have undefined behavior to both the stringbuilder and the
# returned string.
proc destroy*(sb: StringBuilder): string =
  shallowCopy result, sb.string
  result.setLen(sb.len)

proc expand(sb: StringBuilder, n: int) =
  var tmp: string
  shallowCopy tmp, sb.string

  let newCapacity = sb.grow(sb, n)
  sb.cap = newCapacity

  sb.string = newStringOfCap(newCapacity)
  sb.string.setLen(newCapacity)
  copyMem(addr sb.string[0] , addr tmp[0] , sb.len)

# appends the string
proc append*(sb: StringBuilder, value: string) =
  let newLength = value.len + sb.len
  if sb.cap < newLength: sb.expand(newLength)
  copyMem(addr sb.string[sb.len] , unsafeAddr value[0] , value.len)
  sb.len = newLength

# appends the string
proc `&=`*(sb: StringBuilder, value: string) {.inline.} =
  append(sb, value)

# appends the char
proc append*(sb: StringBuilder, value: char) =
  let newLength = sb.len + 1
  if sb.cap < newLength: sb.expand(newLength)
  sb.string[sb.len] = value
  sb.len = newLength

# appends the char
proc `&=`*(sb: StringBuilder, value: char) {.inline.} =
  append(sb, value)

# truncates the string without changing the total capacity
proc truncate*(sb: StringBuilder, n: int) {.inline.} =
  sb.len = if n > sb.len: 0 else: sb.len - n

# sets the length of the string, cannot be greater than the current length
proc setLen*(sb: StringBuilder, n: int) {.inline.} =
  if n < sb.len: sb.len = n

# create a new stringbuilder with the specified, or default, capacity
proc newStringBuilder*(cap: int = defaultCapacity, grow: Grow = doubling): StringBuilder =
  new(result)
  result.grow = grow
  result.cap = if cap < 1: defaultCapacity else: cap
  result.string = newStringOfCap(result.cap)
  result.string.setLen(result.cap)

# create a new stringbuilder with an initial string
proc newStringBuilder*(init: string, grow: Grow = doubling): StringBuilder =
  result = newStringBuilder(init.len + defaultCapacity, grow)
  result.append(init)
