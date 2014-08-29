window.badges = [];
var displayed = false;
$('explanation').hide();

$('#unbake').click(function(e) {
  if (displayed) return;
  $(this).hide();
  ParseBadges(function(badge) {
    var badgeInfo = $('<div>' + badge.assertion.badge.name + ' :: ' + badge.assertion.badge.description + '</div>');
    badgeInfo.hide();
    $('#assertion').append(badgeInfo);
    window.badges.push(badge);
    badgeInfo.fadeIn(function() {$('explanation').fadeIn();});
    displayed = true;
  });
});
