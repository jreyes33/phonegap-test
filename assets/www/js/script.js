var onContactSuccess = function(contacts) {
  $.each(contacts, function(idx, value) {
    if (value.phoneNumbers) {
      $('#main').append('<p><strong>' + value.displayName + '</strong>: ' + value.phoneNumbers[0].value + '</p>');
    }
  });
}

var onContactError = function(err) {
  console.log('An error has occured: ' + err.code);
}

$(document).on('deviceready', function() {
  navigator.contacts.find(["*"], onContactSuccess, onContactError);
});

// jQuery Mobile initialization
$(document).on('mobileinit', function() {
  // Override jQuery Mobile defaults
  $.mobile.defaultPageTransition = 'slide';
});

// jQuery Mobile page initialization
$(document).on('pageinit', function() {

});
