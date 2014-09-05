# Tests
-----

Tests are written in mocha.

    path = require 'path'
    assert = require 'assert'
    jsdom = require 'jsdom'
    badge = '
    <img src="https://curlee.github.io/openbadges-displayer.js/demobadge.png">'
    obd = path.join '..', 'dist', 'openbadges-displayer.min.js'
    win = ''

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
            assert.equal win.openbadges.unbaked, false
            done()

Test the `unbake()` function

      describe '#unbake', ()->
        it 'should return true if badge is unbaked', (done)->
          windowAssert (win)->
            win.openbadges.unbake()
            assert.equal win.openbadges.unbaked, true
            done()