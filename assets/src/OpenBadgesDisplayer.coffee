(()->
  PNGBaker = require '../vendor/png-baker.js'
  previousOBD = @obd
  breaker = {}
  
  obd = (obj)->
    if obj instanceof obd
      return obj
    
    if @ not instanceof obd
      return new obd obj

    @_wrapped = obj

  # export for node
  if typeof exports is not 'undefined'
    if typeof module is not 'undefined' and module.exports
      exports = module.exports = obd
    
    exports.obd = obd
  else
    @obd = obd

  obd.VERSION = '0.0.1'

  # methods
  obd.init = () ->

    @disable_debug()

    @insert_css()
    @badges = []
    @load_images()
    @parse_meta_data()

  obd.eneable_debug = () ->
    console.log = @old_logger

  obd.disable_debug = () ->
    @old_logger = console.log
    console.log = () ->

  obd.insert_css = () ->
    link = document.createElement 'link'
    link.href = '/css/openbadges.css'
    link.type = 'text/css'
    link.rel = 'stylesheet'
    document.getElementsByTagName('head')[0].appendChild link

  obd.load_images = () ->
    @images = document.getElementsByTagName 'img'

  obd.parse_meta_data = () ->
    xhr = null
    console.log 'parsing meta data'
    self = @

    for img in self.images
      self.parse_badge img

  obd.parse_badge = (img) ->
    xhr = new XMLHttpRequest()
    xhr.open 'GET', img.src, true
    xhr.responseType = 'arraybuffer'
    
    xhr.onload = () =>
      if xhr.status is 200
        try
          baked = PNGBaker xhr.response

          # Strip non-ascii characters.
          # Using regex found here: http://stackoverflow.com/a/20856252
          assertion = JSON.parse baked.textChunks['openbadges'].replace(
            /[^A-Za-z 0-9 \.,\?""!@#\$%\^&\*\(\)-_=\+;:<>\/\\\|\}\{\[\]`~]*/g,
            ''
          )

          @badges.push {
            assertion : assertion
            img: img
          }

          @display_badge assertion, img

        catch error

    xhr.ontimeout = () -> console.error "The xhr request timed out."
    xhr.onerror = () -> console.log 'error getting badge data'

    xhr.send null

  obd.display_badge = (assertion, img) ->
    badgeTitle = assertion.badge.name
    badgeInfo = assertion.badge.description
    height = 100

    newDiv = document.createElement 'div'
    newImg = document.createElement 'div'
    newSpan = document.createElement 'span'
    newStrong = document.createElement 'strong'
    newP = document.createElement 'p'
    newA = document.createElement 'a'

    newDiv.setAttribute 'class', 'open-badge-thumb'
    newImg.setAttribute 'class', 'badgeLogo'
    newStrong.setAttribute 'class', 'badgeTitle'
    newSpan.setAttribute 'class', 'ob-info'
    newA.setAttribute 'href', '#'

    badgeTitle = document.createTextNode badgeTitle
    badgeInfo = document.createTextNode badgeInfo
    link = document.createTextNode '[more]'

    newA.appendChild link

    newStrong.appendChild badgeTitle
    newP.appendChild newStrong
    newP.appendChild badgeInfo
    newP.appendChild newA

    newSpan.appendChild newP

    newDiv.appendChild newImg
    newDiv.appendChild newSpan
    img.parentNode.insertBefore newDiv, img
    newDiv.appendChild img

  return obd.init()
).call(@)