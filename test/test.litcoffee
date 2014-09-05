# Tests
-----

Tests are written in mocha.

    path = require 'path'
    assert = require 'assert'
    jsdom = require 'jsdom'
    obd = path.join '..', 'dist', 'openbadges-displayer.min.js'
    win = ''

Currently we are relying on an image hosted by one of the authors on Github.
This needs a better solution as Github times out occasionally which causes the
tests to timeout and fail. Also, relying on an external file like this is
terrible practice.

    badge = '
    <img src="https://curlee.github.io/openbadges-displayer.js/demobadge.png">'

## Functions
-----

Make testing easier. Pass this function a callback.

jsdom creates a page with openbadges-displayer.min.js attached
and passes the window to your callback.

    windowAssert = (callback)->
      jsdom.env(
        badge
        [obd]
        done: (err, window)->
          callback window
      )

## The tests
-----

Tests for the OpenBadgesDisplayer class.

    describe 'OpenBadgesDisplayer', () ->

Make sure all the variables we expect exist.

      describe '#properties', ()->
        it 'should return true if all properties are present', (done)->
          windowAssert (win)->
            for p in [
              'opts'
              'unbaked'
              'old_logger'
            ]
              assert win.openbadges[p]?, p + ' does not exist'
            done()

Make sure all the functions we expect exist.

      describe '#functions', ()->
        it 'should return true if all functions are present', (done)->

          windowAssert (win)->
            for f in [
              'constructor'
              'unbake'
              'allow_debugging'
              'init_lightbox'
              'insert_css'
              'load_images'
              'parse_meta_data'
              'parse_badge'
              'display_badge'
              'show_lightbox'
              'hide_lightbox'
              'allow_scrolling'
            ]
              assert win.openbadges[f]?, f + ' does not exist'
            done()

Test the default value of unbaked.

      describe '#unbaked', ()->
        it 'should return false if badge is not unbaked', (done)->
          windowAssert (win)->
            done assert.equal win.openbadges.unbaked, false

Test the `unbake()` function

      describe 'unbaked', ()->
        it 'should return true if badge is unbaked', (done)->
          windowAssert (win)->
            win.openbadges.unbake()
            done assert.equal win.openbadges.unbaked, true

      describe 'opts', ()->
        it 'should return true if opts.foo is bar', (done)->
          windowAssert (win)->
            options = {foo:'bar'}
            win.openbadges.unbake options
            done assert.deepEqual win.openbadges.opts, options

        it 'should return true if opts is {}', (done)->
          windowAssert (win)->
            win.openbadges.unbake()
            done assert.deepEqual win.openbadges.opts, {}

      describe 'images', ()->
        it 'should have a length of 1', (done)->
          windowAssert (win)->
            win.openbadges.unbake()
            done assert.equal win.openbadges.images.length, 1