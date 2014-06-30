var baker = require('../vendor/png-baker');
var _ = require('underscore');
var fs = require('fs');
var insertCss = require('insert-css');
var css = fs.readFileSync(__dirname + '/badgeFlip.css');
var $ = require('jquery');

function MozBadgeParser() {
  this.selector = 'img.moz-open-badge';

  this.parse = function() {
    var badge = {};
    var xhr = null;
    var baked = null;
    var json = null;

    _.each(self.elems, function(i) {
      console.log("loading ", i.src);

      badge = {}
      xhr = new XMLHttpRequest();
      
      xhr.open('GET', i.src, true);
      xhr.responseType = 'arraybuffer';
      xhr.onload = function(e) {
        if (this.status == 200) {
          baked = baker(this.response);

          // Strip non-ascii characters.
          // Using regex found here: http://stackoverflow.com/a/20856252
          json = baked.textChunks['openbadges'].replace(
            /[^A-Za-z 0-9 \.,\?""!@#\$%\^&\*\(\)-_=\+;:<>\/\\\|\}\{\[\]`~]*/g,
            ''
          );
          
          badge.assertion = JSON.parse(json);

          badge.image = i.src;
          badge.el = i;
          if (self.cb) {
            self.cb(badge);
          }
        }
      }

      xhr.send();
    });
  }
}

var ParseBadges = function() {
  var self = this;
  self.parser = new MozBadgeParser;

  self.cb = null;
  self.elems = [];
  self.args = arguments.length;

  if (self.args < 0 || self.args > 2) {
    throw("usage: ParseBadges(images, callback) or ParseBadges() if used as a browser script");
    return;
  }

  if (args == 2) {
    self.elems = arguments[0];
    self.cb = arguments[1];
  }
  else {
    self.elems = $(document).find(self.parser.selector);

    if (args == 1) {
      self.cb = arguments[0];
    }
  }

  self.parser.parse();
}

module.exports.ParseBadges = ParseBadges;
$(document).ready(
  function() {
    window.ParseBadges = ParseBadges;
  }
);
