$ = jQuery

updateCount = () ->
  switch $('#show-filter-fieldset :checked').val()
    when 'all'
      $('#count-info').text("#{$('#valid-contacts li :checked').length} de #{$('#valid-contacts li :checkbox').length}")
    when 'only-checked'
      $('#count-info').text("#{$('#valid-contacts li :checkbox:visible').length}")
    when 'only-unchecked'
      $('#count-info').text("#{$('#valid-contacts li :checkbox:visible').length}")


updateList = () ->
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

  if contacts? then for contact in contacts
    unless contact.name? then continue
    $contact = $("""
      <li>
        <h3>#{contact.name.formatted}</h3>
        <fieldset data-role="controlgroup" data-mini="true"></fieldset>
      </li>
      """)

    if contact.phoneNumbers?
      for number, i in contact.phoneNumbers
        switch new PhoneNumber(number.value).isUpdatableEcuadorianMobile()
          when 'yes' then checked = 'checked'
          when 'maybe' then checked = ''
          when 'no' then continue

        $contact.children('fieldset').append("""
          <label>
            <input type="checkbox" name="checkbox[#{contact.id}][#{i}]" #{checked} data-theme="b">
            [#{contact.id}][#{i}] #{number.type}: #{number.value}
          </label>
          """)

      $contactsList = $contactsList.add($contact) if $contact.find('label').length

  if $contactsList.length
    $('#valid-contacts').append($contactsList.tsort())
    updateCount()
  else
    $('#contacts-content').html('<p>No se cargó ningún contacto.</p>')

onContactError = (err) ->
  $('#contacts-content').html("<p>Error al cargar los contactos: #{err.code}</p>")

$(document).on 'deviceready', () ->
  navigator.contacts.find(["*"], onContactSuccess, onContactError)


###
 * jQuery Mobile events
###

# jQuery Mobile initialization
$(document).on 'mobileinit', () ->
  # Override jQuery Mobile defaults
  $.mobile.ajaxEnabled = false
  $.mobile.buttonMarkup.hoverDelay = 100
  $.mobile.defaultPageTransition = 'none'
  $.mobile.pushStateEnabled = false

# jQuery Mobile page initialization
$(document).on 'pageinit', () ->
  $('#contacts').on 'change', '#valid-contacts li :checkbox', updateCount

  $('#contacts').on 'change', '#show-filter-fieldset input', updateList


# jQuery Mobile page change
$(document).on 'pagechange', () ->

