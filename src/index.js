var baker = require('../vendor/png-baker');
var _ = require('underscore');
var $ = require('jquery');


var _parser = function(images, callback) {
  _.each(images, function(i) {
    console.log("loading ", i.src);

    var badge = {}
    var xhr = new XMLHttpRequest();
    
    xhr.open('GET', i.src, true);
    xhr.responseType = 'arraybuffer';
    xhr.onload = function(e) {
      if (this.status == 200) {
        var baked = baker(this.response);
        badge.assertion = JSON.parse( 
          $.parseHTML( baked.textChunks['openbadges'].toString() )
        );
        badge.image = i.src;
        badge.el = i;
        if (callback) callback(badge)
      }
    }

    xhr.send();
  })

}

var ParseBadges = function() {
  var cb = null;
  var imgs = [];
  var args = arguments.length;

  if (args < 0 || args > 2) {
    throw("usage: ParseBadges(images, callback) or ParseBadges() if used as a browser script");
    return;
  }

  if (args == 2) {
    imgs = arguments[0];
    cb = arguments[1];
  }
  else {
    imgs = $(document).find('img');

    if (args == 1) {
      cb = arguments[0];
    }
  }

  _parser(imgs, cb);
}

module.exports.ParseBadges = ParseBadges;
$(document).ready(
  function() {
    window.ParseBadges = ParseBadges;
    ParseBadges();
  }
);