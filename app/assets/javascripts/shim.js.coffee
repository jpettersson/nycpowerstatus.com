unless window.console
  window.console =
    log: (args...)->

unless Array::filter
  Array::filter = (fun) -> #, thisp
    len = @length >>> 0
    throw new TypeError() unless typeof fun is "function"
    res = []
    thisp = arguments[1]
    i = 0

    while i < len
      if i of this
        val = this[i]
        res.push val if fun.call(thisp, val, i, this)
      i++
    res

unless "map" of Array::
  Array::map = (mapper, that) -> #opt
    other = new Array(@length)
    i = 0
    n = @length

    while i < n
      other[i] = mapper.call(that, this[i], i, this)  if i of this
      i++
    other