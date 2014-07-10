# Open Badges Displayer
A Javascript client library for easily displaying meta-information about
baked open badges. `openbadges-displayer.js` is under active development, not
all features are currently implemented!

## Usage

_Goal_: Include the library at the bottom of an html page (near the `</body>`
tag would be best) that you have baked open badges on. When the page loads in
your browser, the library will detect which images are open badges and add
their metadata to the page.

_Current Status_: If you include the libary in the page, badges will be unbaked
and included in `window.badges` which you can explore in the browser console.
You can also manually unbake, which is described next.

## Development

`openbadges-displayer.js` is under active development. To help out, fork this
library and submit pull requests with new features. Get started by picking up an
[issue](http://github.com/cmcavoy/openbadges-displayer.js/issues), or filing
[bug](http://github.com/cmcavoy/openbadges-displayer.js/issues).

### Requirements

[Node v0.10.29](http://nodejs.org/)

### Installation

Clone this repo.

`git clone <url> openbadges-displayer.js`

Change to the new directory.

`cd openbadges-displayer.js`

To install requirements, compile code and run the demo server:

`npm start`

Requirements will only install once unless they change.

Go to demo url in your browser.

`http://localhost:3000`

### Compiling

Compiling creates the directory __openbadges-displayer.js/dist/demo__ and the
files __openbadges-displayer.js/dist/openbadges-displayer.min.js__ and
__openbadges-displayer.js/dist/openbadges-displayer.min.css__

The demo is compiled from the `assets/client` and `assets/server`
folders.

Gulp uses browserify and uglify to create __openbadges-displayer.min.js__ which
is compiled from __assets/src/OpenBadgesDisplayer.coffee__ and its requirement,
__assets/vendor/png-baker.js__

__openbadges-displayer.min.css__ is compiled with gulp-minify-css and gulp-less.

## Future

### Fix requirements
Install png-baker with node rather than manually.

### Manual Unbaking

If you'd rather manually unbake the badges on your page and choose how they're
displayed, you can use the `ParseBadges(callback)` format of the library. An
example of how this works is
[here](https://github.com/cmcavoy/openbadges-displayer.js/blob/master/resources/demoApp.js).

Use `openbadges-displayer.js` to display your badges how you want to!

### Creating a new parser

First, specify a selector. jquery.find is used with this selector.

Second, specify some parsing rules. You can access the found elements and a
callback function via:

self.elements
self.callback

**Example:**

<pre><code>
function MyParser() {
  this.selector = '<div>'; // Dom selector, all div elements will be found.

  this.parse = function() {
    // Parsing rules
  }
}
</pre></code>

**MozBadgeParser** looks for elements that match *img.moz-open-badge* and gets
meta data from found images from within the parse function.