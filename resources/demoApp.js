window.badges = [];
ParseBadges(function(badge) {
  $('#assertion').append('<div>' + badge.assertion.badge.name + ' :: ' + badge.assertion.badge.description + '</div>');
  window.badges.push(badge);
});
