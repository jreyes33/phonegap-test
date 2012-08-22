class PhoneNumber
  constructor: (@value, @type) ->
    @removeDelimiters() if @value?

  hasValidChars: ->
    return @value? and not /[^\d\(\)\+\-\. ]/.test @value

  removeDelimiters: ->
    @cleanValue = @value.replace(/[\(\)\-\. ]/g, '')

  isEcuadorian: ->
    if @value?
      @removeDelimiters()
      return /^(\+593|0)/.test @cleanValue
    else
      return false


root = exports ? window
root.PhoneNumber = PhoneNumber
