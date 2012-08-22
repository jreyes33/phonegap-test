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
      if @hasValidChars() and @isEcuadorian() and @hasValidLength()
        if @cleanValue.match(/^(\+593|0)(\d)/)[2] in ['8', '9']
          return 'yes'
        else
          return 'maybe'
      else
        return 'no'
    else
      return 'no'

  updateEcuadorianMobile: (forceMaybe) ->
    if @value?
      switch @isUpdatableEcuadorianMobile()
        when 'yes'
          return @updatedValue = @cleanValue.replace(/^(\+593|0)(\d)/, '$19$2')
        when 'maybe'
          return @updatedValue = if forceMaybe then @cleanValue.replace(/^(\+593|0)(\d)/, '$19$2') else @value
        when 'no'
          return @updatedValue = @value
    else
      return null

root = exports ? window
root.PhoneNumber = PhoneNumber
