$ = jQuery

onContactSuccess = (contacts) ->
  $('#contacts [data-role="content"]').html("""
    <div data-role="collapsible" data-collapsed="false" data-inset="false" data-theme="b">
      <h2>Contactos cargados</h2>
      <ul id="valid-contacts" data-role="listview" data-filter="true" data-filter-theme="b" data-autodividers="true" data-divider-theme="a"></ul>
    </div>
    """)
  $contactsList = $()

  if contacts? then for contact in contacts
    $contact = $("""
      <li>
        <h3>#{contact.name.formatted}</h3>
        <fieldset data-role="controlgroup"></fieldset>
      </li>
      """)

    if contact.phoneNumbers?
      for number, i in contact.phoneNumbers
        $contact.children('fieldset').append("""
          <label>
            <input type="checkbox" name="checkbox-#{contact.id}-#{i}" checked="checked" data-theme="b" data-mini="true">
            [#{contact.id}-#{i}] #{number.type}: #{number.value}
          </label>
          """)

      $contactsList = $contactsList.add($contact)

  if $contactsList.length
    $('#valid-contacts').html('').append($contactsList.tsort())
  else
    $('#contacts [data-role="content"]').html('<p>No se cargó ningún contacto.</p>')

onContactError = (err) ->
  console.log("Error loading the contacts: #{err.code}")

$(document).on 'deviceready', () ->
  navigator.contacts.find(["*"], onContactSuccess, onContactError)


###
 * jQuery Mobile events
###

# jQuery Mobile initialization
$(document).on 'mobileinit', () ->
  # Override jQuery Mobile defaults
  $.mobile.defaultPageTransition = 'none'

# jQuery Mobile page initialization
$(document).on 'pageinit', () ->


# jQuery Mobile page change
$(document).on 'pagechange', (e, d) ->

