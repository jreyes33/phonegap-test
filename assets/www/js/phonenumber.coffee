class PhoneNumber
  constructor: (@value, @type) ->

  hasValidChars: ->
    return @value? and not /[^\d\(\)\+\-\. ]/.test @value

  removeDelimiters: ->
    @cleanValue = @value.replace(/[\(\)\-\. ]/g, '')

root = exports ? window
root.PhoneNumber = PhoneNumber
