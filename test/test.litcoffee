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

Make testing easier.

    jsdom.env(
      badge
      [obd]
      done: (err, window)->
        win = window
    )

## The tests
-----

Tests for the OpenBadgesDisplayer class.

    describe 'OpenBadgesDisplayer', () ->

### vars

Test class variables

      describe '#properties', ()->
        it 'should return true if all properties are present', (done)->
          jsdom.env(
            badge
            [obd]
            done: (err, window)->
              for p in [
                'opts'
                'unbaked'
                'old_logger'
              ]
                assert win.openbadges[p]?, p + ' does not exist'
              done()
          )

      describe '#functions', ()->
        it 'should return true if all functions are present', (done)->
          jsdom.env(
            badge
            [obd]
            done: (err, window)->
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
          )