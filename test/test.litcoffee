# Tests
-----

Tests are written in mocha.

    path = require 'path'
    assert = require 'assert'
    jsdom = require 'jsdom'
    badge = '
    <img src="https://curlee.github.io/openbadges-displayer.js/demobadge.png">'
    obd = path.join '..', 'dist', 'openbadges-displayer.min.js'

## Tests
-----

Tests for the OpenBadgesDisplayer class.

    describe 'OpenBadgesDisplayer', () ->

### vars

Test class variables

      describe '#vars', ()->
        it 'should return true when opts is {}', (done)->
          jsdom.env(
            badge
            [obd]
            done: (err, window)->
              done assert.equal typeof window.openbadges.opts, 'object'
          )


