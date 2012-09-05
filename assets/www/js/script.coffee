$ = jQuery
appDir = null
checkedContacts = null
loadedContacts = null

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

restoreBackup = ->
  if confirm "¿Está seguro que desea revertir los #{$(@).children('.ui-li-count').text()} cambios realizados en la fecha indicada?"
    for item in $(@).data('backup')
      loadedContacts[item.contactIdx].phoneNumbers[item.numberIdx].value = item.oldNumber
      loadedContacts[item.contactIdx].save ->
          console.log "Saved contact #{retObj.contactId}-#{retObj.numberIdx}"
        , (err) ->
          console.log "ERRCODE: #{JSON.stringify err}, error saving contact #{retObj.contactId}-#{retObj.numberIdx}"

readBackupsSuccess = (entries) ->
  $backupList = $()
  for entry in entries
    if entry.isFile and matches = entry.name.match(/^backup\-(\d{13})\.json$/)
      entry.file (file) ->
          reader = new FileReader()
          reader.onload = (e) ->
            backupData = JSON.parse(e.target.result)
            date = matches[1]
            $backup = $("""
              <li>
                <a href="#" class="restore-backup">
                  #{date.getFullYear()}-#{date.getMonth() + 1}-#{date.getDate()} #{date.getHours()}:#{date.getMinutes()}:#{date.getSeconds()}
                  <span class="ui-li-count">#{backupData.length}</span>
                </a>
              </li>
              """)

            $backup.find('.restore-backup').data('backup', backupData)
            $backupList.add($backup)

          reader.onerror = (e) ->
            console.log "ERROR reading backup file: #{err.code}"

          reader.readAsText file

        , (err) ->
          console.log "ERROR obtaining file object: #{err.code}"

  $('#backup-list').append $backupList

readBackupsError = (err) ->


fillBackupList = ->
  appDir.createReader().readEntries readBackupsSuccess, readBackupsError

backupFsSuccess = (fileSystem) ->
  fileSystem.root.getDirectory 'org.jreyes.actualizame', {create: true}, appDirSuccess, appDirError

backupFsError = (err) ->
  console.log "ERROR getting the filesystem: #{err.code}"

appDirSuccess = (directoryEntry) ->
  appDir = directoryEntry
  fillBackupList()

appDirError = (err) ->
  appDir = null
  console.log "ERROR getting the app directory: #{err.code}"

backupFileSuccess = (fileEntry) ->
  fileEntry.createWriter (writer) ->
      writer.onwrite = (e) ->
      writer.onerror = (e) ->

      writer.truncate 0
      writer.write checkedContacts.get()

    , (err) ->
        console.log "ERROR writing to backup file: #{err.code}"


backupFileError = (err) ->
  console.log "ERROR creating the backup file: #{err.code}"

contactSuccess = (contacts) ->
  loadedContacts = contacts
  $contactList = $()

  if loadedContacts? then for contact, i in loadedContacts
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

      $contactList = $contactList.add($contact) if $contact.find('label').length

  if $contactList.length
    $('#valid-contacts').append($contactList.tsort())
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
        contactIdx: $(@).data('idx')
        numberIdx: matches[2]
        # Don't retrieve using .data because it converts to int when it can.
        oldNumber: $(@).attr('data-old-number')
        newNumber: $(@).attr('data-new-number')
      }
      loadedContacts[retObj.contactIdx].phoneNumbers[retObj.numberIdx].value = retObj.newNumber
      loadedContacts[retObj.contactIdx].save ->
          console.log "Saved contact #{retObj.contactId}-#{retObj.numberIdx}"
        , (err) ->
          console.log "ERRCODE: #{JSON.stringify err}, error saving contact #{retObj.contactId}-#{retObj.numberIdx}"

      return retObj

    if appDir?
      appDir.getFile "backup-#{Date.now()}.json", {create: true}, backupFileSuccess, backupFileError

contactError = (err) ->
  $('#contacts-content').html("<p>Error al cargar los contactos: #{err.code}</p>")

$(document).on 'deviceready', ->
  navigator.contacts.find ["*"], contactSuccess, contactError
  window.requestFileSystem LocalFileSystem.PERSISTENT, 0, backupFsSuccess, backupFsError


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

  $('#backups').on 'tap', '.restore-backup', restoreBackup
