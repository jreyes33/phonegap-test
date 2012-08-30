$ = jQuery

updateCount = ->
  switch $('#show-filter-fieldset :checked').val()
    when 'all'
      $('#count-info').text("#{$('#valid-contacts li :checked').length} de #{$('#valid-contacts li :checkbox').length}")
    when 'only-checked'
      $('#count-info').text("#{$('#valid-contacts li :checkbox:visible').length}")
    when 'only-unchecked'
      $('#count-info').text("#{$('#valid-contacts li :checkbox:visible').length}")


updateList = ->
  $('#valid-contacts li, #valid-contacts li .ui-checkbox').show()
  switch $('#show-filter-fieldset :checked').val()
    when 'only-checked'
      $('#valid-contacts li :checkbox:not(:checked)').parents('.ui-checkbox').hide()
    when 'only-unchecked'
      $('#valid-contacts li :checkbox:checked').parents('.ui-checkbox').hide()

  $('#valid-contacts li:not(:has(.ui-checkbox:visible))').hide()
  updateCount()

onContactSuccess = (contacts) ->
  $contactsList = $()

  if contacts? then for contact, i in contacts
    continue unless contact.name?
    $contact = $("""
      <li>
        <h3>#{contact.name.formatted}</h3>
        <fieldset data-mini="true"></fieldset>
      </li>
      """)

    if contact.phoneNumbers?
      for number, j in contact.phoneNumbers
        phoneNumber = new PhoneNumber(number.value)
        switch phoneNumber.isUpdatableEcuadorianMobile()
          when 'yes' then checked = 'checked'
          when 'maybe' then checked = ''
          when 'no' then continue # Exit for and move to next number.

        $contact.children('fieldset').append("""
          <label>
            <input type="checkbox" name="contacts[#{contact.id}][#{j}]" #{checked} data-theme="b"
              data-idx="#{i}" data-old-number="#{phoneNumber.value}"
              data-new-number="#{phoneNumber.updateEcuadorianMobile(true)}">
            [#{contact.id}][#{j}] #{number.type}: #{number.value}
          </label>
          """)

      $contactsList = $contactsList.add($contact) if $contact.find('label').length

  if $contactsList.length
    $('#valid-contacts').append($contactsList.tsort())
    $('#contacts .footer').show()
    updateCount()
  else
    $('#contacts-content').html('<p>No se cargó ningún contacto.</p>')
    $('#contacts .footer').hide()

  $('#contacts').on 'tap', '#update-button', ->
    checkedContacts = $('#valid-contacts li :checkbox:checked').map ->
      matches = $(@).attr('name').match(/\[(\d+)\]\[(\d+)\]/)
      retObj = {
        contactId: matches[1]
        numberIdx: matches[2]
        # Don't retrieve using .data because it converts to int when it can.
        oldNumber: $(@).attr('data-old-number')
        newNumber: $(@).attr('data-new-number')
      }
      contacts[$(@).data('idx')].phoneNumbers[retObj.numberIdx].value = retObj.newNumber
      contacts[$(@).data('idx')].save ->
          console.log "Saved contact #{retObj.contactId}-#{retObj.numberIdx}"
        , (err) ->
          console.log "ERRCODE: #{JSON.stringify err}, error saving contact #{retObj.contactId}-#{retObj.numberIdx}"

      return retObj

    console.log JSON.stringify(checkedContacts.get())

onContactError = (err) ->
  $('#contacts-content').html("<p>Error al cargar los contactos: #{err.code}</p>")

$(document).on 'deviceready', ->
  navigator.contacts.find(["*"], onContactSuccess, onContactError)


###
 * jQuery Mobile events
###

# jQuery Mobile initialization
$(document).on 'mobileinit', ->
  # Override jQuery Mobile defaults
  $.mobile.ajaxEnabled = false
  $.mobile.buttonMarkup.hoverDelay = 100
  $.mobile.defaultPageTransition = 'none'
  $.mobile.pushStateEnabled = false

# jQuery Mobile page initialization
$(document).on 'pageinit', ->


# jQuery Mobile page change
$(document).on 'pagechange', ->


#jQuery document ready
$ ->
  $('#contacts').on 'change', '#valid-contacts li :checkbox', updateCount

  $('#contacts').on 'change', '#show-filter-fieldset input', updateList
