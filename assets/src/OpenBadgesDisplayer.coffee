baker = require '../vendor/png-baker'
$ = require 'jquery'
_ = require 'underscore'

class OpenBadgesDisplayer 
  initialize: () =>
    @images = $ 'img'
    console.log @images
    @parse_meta_data()

  parse_meta_data: () =>
    xhr = null
    
    _.each @images, (img) ->
      console.log img
      badge = {}
      xhr = new XMLHttpRequest()
      xhr.open 'GET', img.src, true
      xhr.responseType = 'arraybuffer'

      xhr.onload = (e)->
        if this.status == 200
          baked = baker this.response

          # Strip non-ascii characters.
          # Using regex found here: http://stackoverflow.com/a/20856252
          json = baked.textChunks['openbadges'].replace(
            /[^A-Za-z 0-9 \.,\?""!@#\$%\^&\*\(\)-_=\+;:<>\/\\\|\}\{\[\]`~]*/g,
            ''
          )
          
          badge.assertion = JSON.parse json

          badge.image = img['src']
          badge.el = img
          if cb
            cb badge

          console.log badge

      xhr.send();

      

module.exports = OpenBadgesDisplayer

obd = new OpenBadgesDisplayer()
obd.initialize()
