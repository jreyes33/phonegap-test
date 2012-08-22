class PhoneNumber
  constructor: (@value, @type) ->
    @cleanValue = @removeDelimiters() if @value?

  hasValidChars: ->
    return @value? and not /[^\d\(\)\+\-\. ]/.test @value

  removeDelimiters: ->
    return @value.replace(/[\(\)\-\. ]/g, '')

  isEcuadorian: ->
    if @value?
      @cleanValue = @removeDelimiters()
      return /^(\+593|0)/.test @cleanValue
    else
      return false

  hasValidLength: ->
    if @value?
      @cleanValue = @removeDelimiters()
      return (@cleanValue[0] == '+' and @cleanValue.length == 12) or
             (@cleanValue[0] == '0' and @cleanValue.length == 9)
    else
      return false


root = exports ? window
root.PhoneNumber = PhoneNumber
