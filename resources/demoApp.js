window.badges = [];
ParseBadges(function(badge) {
  $('#assertion').append('<li>' + badge.assertion.badge.name + ' :: ' + badge.assertion.badge.description + '</li>');
  window.badges.push(badge);
});
