# OpebBadgesDisplayer
-----

## Initialization
-----

Require some libs.

    _ = require 'underscore'
    path = require 'path'
    insertCss = require 'insert-css'
    fs = require 'fs'
    PNGBaker = require 'png-baker.js'
    tplfile = null
    badgeTplFile = null

Read and set the modal template file contents.

    fs.readFile __dirname + '/modal.tpl', 'utf8', (err, fileContents) ->
      if err
        throw err
      tplfile = _.template fileContents

Get the distro css file contents.

    css = fs.readFileSync __dirname + '/../../dist/openbadges-displayer.min.css'

Read and set the badge template contents.

    fs.readFile __dirname + '/badge.tpl', 'utf8', (err, fileContents) ->
      if err
        throw err
      badgeTplFile = _.template fileContents

## OpenBadgesDisplayer
-----

Declare the main class.

    class OpenBadgesDisplayer
      opts: {}
      unbaked: false

      constructor: (options) ->
        @disable_debug()
        @init_lightbox()

        # If esc key is pressed, close the lightbox modal.
        window.addEventListener 'keydown', (e) =>
          if e.keyCode == 27
            @hideLightbox()

        @insert_css()
        @badges = []

## unbake
-----

Unbake and display any badges on the page.

Calls `load_images` AND `parse_meta_data`

      unbake: (options)->
        # check for existence of options
        if not @unbaked
          @unbaked = true
          @opts = if options? then options else {}
          @load_images()
          @parse_meta_data()

## enable_debug
-----

Enable debugging.

      enable_debug: () ->
        console.log = @old_logger

## disable_debug
-----

Disable debugging.

      disable_debug: () ->
        @old_logger = console.log
        console.log = () ->

## init_lightbox
-----

Initialize a lightbox.

      init_lightbox: () ->

        # Ceate the overlay.

        @overlay = document.createElement 'div'
        @overlay.setAttribute 'class', 'ob-overlay'
        @overlay.addEventListener 'click', () =>
          @hideLightbox()
        @overlay.style.display = 'none'

        # Create the lightbox

        @lightbox = document.createElement 'div'
        @lightbox.setAttribute 'class', 'ob-lightbox container'
        @lightbox.setAttribute 'id', 'ob-lightbox'
        @lightbox.style.display = 'none'

        # Append the overlay and lightbox to body.

        document.body.appendChild @overlay
        document.body.appendChild @lightbox

## insert_css
-----

Insert the css.

      insert_css: () ->
        console.log 'Inserting css'
        insertCss css

## load_images
-----

Load the images.

      load_images: () ->
        console.log 'Loading images'

        if @opts.id
          @images = [document.getElementById @opts.id]
        else if @opts.className
          @images = document.getElementsByClassName @opts.className
        else
          @images = document.getElementsByTagName 'img'

## parse_meta_data
-----

Parse the meta data.

      parse_meta_data: () ->
        console.log 'Parsing meta data'
        xhr = null
        self = @

        for img in self.images
          self.parse_badge img

## parse_badge
-----

Parse the badge data.

      parse_badge: (img) ->
        console.log 'Parse badge'

        xhr = new XMLHttpRequest()
        xhr.open 'GET', img.src, true
        xhr.responseType = 'arraybuffer'
        
        xhr.onload = () =>
          if xhr.status is 200
            try
              baked = new PNGBaker xhr.response

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

## display_badge
-----

Display the badge.

      display_badge: (assertion, img) ->
        console.log 'Display badge'

        data = {
          title:assertion.badge.name
          description:assertion.badge.description
          src:img.src
        }
        badgeID = 'badge_' + new Date().getTime().toString()

        newDiv = document.createElement 'div'
        newDiv.setAttribute 'class', 'open-badge-thumb'
        newDiv.setAttribute 'id', badgeID
        newDiv.innerHTML = badgeTplFile data
        
        img.parentNode.insertBefore newDiv, img
        newDiv.appendChild img

        newDiv.addEventListener 'click', () =>
          @showLightbox data

## showLightbox
-----

Show the lightbox.

      showLightbox: (data) ->
        @scrolling false
        @overlay.style.display = 'block'
        @lightbox.style.display = 'block'
        document.getElementById('ob-lightbox').innerHTML = tplfile data
        document.getElementById('close-modal').addEventListener 'click', () =>
          @hideLightbox()

## hideLightbox
-----

Hide the lightbox.

      hideLightbox: () ->
        @overlay.style.display = 'none'
        @lightbox.style.display = 'none'
        @scrolling true


## scrolling
-----

Enables / disables browser scrolling.

      scrolling: (scroll) ->
        document.documentElement.style.overflow =
          if scroll then 'auto' else 'hidden'

        # ie support
        document.body.scroll = if scroll then 'yes' else 'no'

## enable_scrolling

Enable browser scrolling.

    enable_scrolling: () ->
      document.documentElement.style.overflow = 'auto'
      document.body.scroll = 'yes' # ie support


## Finalization
-----

    window.openbadges = new OpenBadgesDisplayer
    module.exports.OpenBadgesDisplayer = OpenBadgesDisplayer