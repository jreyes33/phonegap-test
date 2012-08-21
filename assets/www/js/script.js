(function() {
  var $, onContactError, onContactSuccess;

  $ = jQuery;

  onContactSuccess = function(contacts) {
    var $contact, $contactsList, contact, i, number, _i, _len, _len2, _ref;
    $('#contacts [data-role="content"]').html("<div data-role=\"collapsible\" data-collapsed=\"false\" data-inset=\"false\" data-theme=\"b\">\n  <h2>Contactos cargados</h2>\n  <ul id=\"valid-contacts\" data-role=\"listview\" data-filter=\"true\" data-filter-theme=\"b\" data-autodividers=\"true\" data-divider-theme=\"a\"></ul>\n</div>");
    $contactsList = $();
    if (contacts != null) {
      for (_i = 0, _len = contacts.length; _i < _len; _i++) {
        contact = contacts[_i];
        $contact = $("<li>\n  <h3>" + contact.name.formatted + "</h3>\n  <fieldset data-role=\"controlgroup\"></fieldset>\n</li>");
        if (contact.phoneNumbers != null) {
          _ref = contact.phoneNumbers;
          for (i = 0, _len2 = _ref.length; i < _len2; i++) {
            number = _ref[i];
            $contact.children('fieldset').append("<label>\n  <input type=\"checkbox\" name=\"checkbox-" + contact.id + "-" + i + "\" checked=\"checked\" data-theme=\"b\" data-mini=\"true\">\n  [" + contact.id + "-" + i + "] " + number.type + ": " + number.value + "\n</label>");
          }
          $contactsList = $contactsList.add($contact);
        }
      }
    }
    if ($contactsList.length) {
      return $('#valid-contacts').html('').append($contactsList.tsort());
    } else {
      return $('#contacts [data-role="content"]').html('<p>No se cargó ningún contacto.</p>');
    }
  };

  onContactError = function(err) {
    return console.log("Error loading the contacts: " + err.code);
  };

  $(document).on('deviceready', function() {
    return navigator.contacts.find(["*"], onContactSuccess, onContactError);
  });

  /*
   * jQuery Mobile events
  */

  $(document).on('mobileinit', function() {
    return $.mobile.defaultPageTransition = 'none';
  });

  $(document).on('pageinit', function() {});

  $(document).on('pagechange', function(e, d) {});

}).call(this);
