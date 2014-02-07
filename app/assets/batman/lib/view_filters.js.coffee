Batman.mixin Batman.Filters,
  formatDate: (date, format) ->
    if date and format
      moment(date).format(format)
    else
      date

  asNamedRoute: (name, args...) ->
    args.pop()
    r = Batman.helpers.camelize(name, true)
    Batsoe.get('routes')[r].call(null, args.join('/')).get('path')