# Open Badges Displayer
---

A Javascript client library for easily displaying meta-information about
baked open badges.

`openbadges-displayer.js` is under active development. To help out, fork this
library and submit pull requests with new features. Get started by picking up an
[issue](http://github.com/cmcavoy/openbadges-displayer.js/issues), or filing
[bug](http://github.com/cmcavoy/openbadges-displayer.js/issues).

## Usage
---

On a webpage with badges, place the following code just before the closing
body tag:

      <script type="text/javascript">
        window.obd.init();
      </script>
    </body>

Badges will be unbaked and included in `window.obd.badges` which you can explore
in the browser console.

Openbadges Displayer will inspect all `img` tags on the page.
Alternately you can specify which elements to inspect by passing options to
`obd.init`.

### Options

**className**
  
  A string representing the classname of elements to inspect.

**id**
  
  A string representing the ID of element to inspect.

**Example:**

      <script type="text/javascript">
        window.obd.init(
          {
            className: 'openbadges'
          }
        );
      </script>

This will force openbadges displayer to inspect all elements with the classname
"openbadges".

## Development
---

### Requirements

[Node v0.10.29](http://nodejs.org/)

### Installation

After cloning this repo:

`npm start`

This will install requirements and then use gulp to compile the code and
run the server. Requirements will only install once unless they change.

### Viewing the demo

After compiling and running the demo server (`npm start` or `gulp`) go to:

[http://localhost:3000](http://localhost:3000)

### Compiling

Compiling creates:

* __openbadges-displayer.js/dist/demo/__ 
* __openbadges-displayer.js/dist/openbadges-displayer.min.js__
* __openbadges-displayer.js/dist/openbadges-displayer.min.css__

The demo is compiled from the `assets/client` and `assets/server`
folders.

Gulp uses browserify and uglify to create __openbadges-displayer.min.js__ which
is compiled from __assets/src/OpenBadgesDisplayer.coffee__ and its requirement,
__assets/vendor/png-baker.js__

__openbadges-displayer.min.css__ is compiled with gulp-minify-css and gulp-less.

### Testing

`gulp test` or `npm test`

Tests are written using coffeescript and are run with gulp-mocha.

## Future
---

### Add more tests

Need more test coverage.

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

**OpenBadgesDisplayer** looks for elements that match *img* and gets
meta data from found images from within the parse function.