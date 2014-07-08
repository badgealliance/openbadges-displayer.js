(()->
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
    @badges = []
    @load_images()
    @parse_meta_data()
    @display_badges()

  obd.load_images = () ->
    @images = document.getElementsByTagName 'img'

  obd.parse_meta_data = () ->
    xhr = null
    console.log 'parsing meta data'
    self = @

    for img in self.images
      self.parse_badge img
    console.log @badges
    for b in @badges
      console.log b.assertion

  obd.parse_badge = (img) ->
    @xhr = new XMLHttpRequest()
    @xhr.open 'GET', img.src, true
    @xhr.responseType = 'arraybuffer'

    @xhr.onload = (e) =>
      if @xhr.status == 200
        baked = PNGBaker @xhr.response

        # Strip non-ascii characters.
        # Using regex found here: http://stackoverflow.com/a/20856252
        json = baked.textChunks['openbadges'].replace(
          /[^A-Za-z 0-9 \.,\?""!@#\$%\^&\*\(\)-_=\+;:<>\/\\\|\}\{\[\]`~]*/g,
          ''
        )
        
        @badges.push {
          assertion:JSON.parse json,
          image:img.src
          obj:img
        }
        console.log @badges

    @xhr.send()

    console.log @badges

  obd.display_badges = () ->
    for badge in @badges
      console.log badge

  return obd.init()
).call(@)