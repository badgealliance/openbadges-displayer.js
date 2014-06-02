var baker = require('../vendor/png-baker')
var _ = require('underscore')
var $ = require('jquery')


var _parser = function(images, callback) {
  _.each(images, function(i) {
    var badge = {}
    console.log("loading ", i.src)
    var xhr = new XMLHttpRequest()
    xhr.open('GET', i.src, true)
    xhr.responseType = 'arraybuffer'
    xhr.onload = function(e) {
      if (this.status == 200) {
        var baked = baker(this.response)
        var assertionText = baked.textChunks['openbadges'].toString()
        if (document) {
          // this is the only way I've been able to get JSON to parse the assertion
          var el = document.createElement('div')
          el.innerHTML = assertionText
          assertionText = el.innerHTML
        }
        var assertion = JSON.parse(assertionText)
        badge.assertion = assertion
        badge.image = i.src
        badge.el = i
        if (callback) callback(badge)
      }
    }
    xhr.send()
  })

}

var ParseBadges = function() {
  if ((arguments.length == 2)
      && (typeof(arguments[0]) == 'object')
      && (typeof(arguments[1]) == 'function')) _parser(arguments[0], arguments[1])
  else if ((arguments.length == 1) && (typeof(arguments[0]) == 'function')) {
    var images = []
    if (document) {
      images = document.getElementsByTagName("img")
    }
    _parser(images, arguments[0])
  } else if (arguments.length == 0 && document) {
    var images = document.getElementsByTagName("img")
    _parser(images)
  }
  else throw("usage: ParseBadges(images, callback) or ParseBadges() if used as a browser script")
}

module.exports.ParseBadges = ParseBadges

if (document) {
  window.ParseBadges = ParseBadges
}
