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

  isUpdatableEcuadorianMobile: ->
    if @value?
      @cleanValue = @removeDelimiters()
      if @hasValidChars() and @isEcuadorian() and @hasValidLength()
        if @cleanValue.match(/^(\+593|0)(\d)/)[2] in ['8', '9']
          return 'yes'
        else
          return 'maybe'
      else
        return 'no'
    else
      return 'no'


root = exports ? window
root.PhoneNumber = PhoneNumber
