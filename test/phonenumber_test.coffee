should = require('chai').should()
{PhoneNumber} = require '../assets/www/js/phonenumber'

describe 'PhoneNumber', ->
  describe '#constructor', ->
    it 'builds without arguments', ->
      phonenumber = new PhoneNumber
      should.exist phonenumber

    it 'builds with a phone number as a single argument', ->
      number = '099123456'
      phonenumber = new PhoneNumber number
      should.exist phonenumber
      phonenumber.value.should.equal number

    it 'builds with a phone number and a type as arguments', ->
      number = '099123456'
      type = 'mobile'
      phonenumber = new PhoneNumber number, type
      should.exist phonenumber
      phonenumber.value.should.equal number
      phonenumber.type.should.equal type


  describe '#hasValidChars', ->
    phonenumber = null
    beforeEach ->
      phonenumber = new PhoneNumber

    it 'returns true when the number does not contain any weird characters', ->
      phonenumber.value = '099123456'
      phonenumber.hasValidChars().should.equal true
      phonenumber.value = '099-123-456'
      phonenumber.hasValidChars().should.equal true
      phonenumber.value = '099 123 456'
      phonenumber.hasValidChars().should.equal true
      phonenumber.value = '099.123.456'
      phonenumber.hasValidChars().should.equal true
      phonenumber.value = '+593 (9) 912-3456'
      phonenumber.hasValidChars().should.equal true

    it 'returns false when the number contains weird characters', ->
      phonenumber.value = '1800-ABCDEF'
      phonenumber.hasValidChars().should.equal false
      phonenumber.value = '09912345p6'
      phonenumber.hasValidChars().should.equal false
      phonenumber.value = '099,123,456'
      phonenumber.hasValidChars().should.equal false
      phonenumber.value = '+593/9/9123456'
      phonenumber.hasValidChars().should.equal false
      phonenumber.value = '*001'
      phonenumber.hasValidChars().should.equal false
      phonenumber.value = '*100#'
      phonenumber.hasValidChars().should.equal false

    it 'returns false when the number is not defined', ->
      phonenumber.hasValidChars().should.equal false


  describe '#removeDelimiters', ->
    it 'removes delimiters from numbers with them', ->
      phonenumber = new PhoneNumber '+59399123456'
      phonenumber.removeDelimiters().should.equal '+59399123456'
      phonenumber.value = '+593(9)9123456'
      phonenumber.removeDelimiters().should.equal '+59399123456'
      phonenumber.value = '099-123-456'
      phonenumber.removeDelimiters().should.equal '099123456'
      phonenumber.value = '09.912.3456'
      phonenumber.removeDelimiters().should.equal '099123456'


  describe '#isEcuadorian', ->
    phonenumber = null
    beforeEach ->
      phonenumber = new PhoneNumber

    it 'returns true when the number is ecuadorian', ->
      phonenumber.value = '+(593)99123456'
      phonenumber.isEcuadorian().should.equal true
      phonenumber.value = '09.912.3456'
      phonenumber.isEcuadorian().should.equal true

    it 'returns false when the number is not ecuadorian', ->
      phonenumber.value = '+1(456)912-3456'
      phonenumber.isEcuadorian().should.equal false


  describe '#hasValidLength', ->
    phonenumber = null
    beforeEach ->
      phonenumber = new PhoneNumber

    it 'returns true when the number\'s length is valid', ->
      phonenumber.value = '+(593)99123456'
      phonenumber.hasValidLength().should.equal true
      phonenumber.value = '08.912.3456'
      phonenumber.hasValidLength().should.equal true

    it 'returns false when the number\'s length is not valid', ->
      phonenumber.value = '+(593)991234567'
      phonenumber.hasValidLength().should.equal false
      phonenumber.value = '08.912.34567'
      phonenumber.hasValidLength().should.equal false


  describe '#isUpdatableEcuadorianMobile', ->
    it 'returns "yes" when the number is certainly an ecuadorian mobile that needs to be updated'

    it 'returns "maybe" when the number could be an ecuadorian mobile that needs to be updated'

    it 'returns "no" when the number is certainly not an ecuadorian mobile that needs to be updated'


  describe '#updateEcuadorianMobile', ->
    it 'updates a number if it is a valid ecuadorian mobile'

    it 'does not update a number if it is not a valid ecuadorian mobile'
