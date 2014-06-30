# Open Badges Displayer
A Javascript client library for easily displaying meta-information about baked open badges. `openbadges-displayer.js` is under active development, not all features are currently implemented!

## Usage

_Goal_: Include the library at the bottom of an html page (near the `</body>` tag would be best) that you have baked open badges on. When the page loads in your browser, the library will detect which images are open badges and add their metadata to the page.

_Current Status_: If you include the libary in the page, badges will be unbaked and included in `window.badges` which you can explore in the browser console. You can also manually unbake, which is described next.

### Manual Unbaking

If you'd rather manually unbake the badges on your page and choose how they're displayed, you can use the `ParseBadges(callback)` format of the library. An example of how this works is [here](https://github.com/cmcavoy/openbadges-displayer.js/blob/master/resources/demoApp.js).

Use `openbadges-displayer.js` to display your badges how you want to!

## Development

`openbadges-displayer.js` is under active development. To help out, fork this library and submit pull requests with new features. Get started by picking up an [issue](http://github.com/cmcavoy/openbadges-displayer.js/issues), or filing [bug](http://github.com/cmcavoy/openbadges-displayer.js/issues).

To get started, fork or clone the repository, then run `npm install` to install all the dependencies.

The library uses [browserify](http://browserify.org/) to build the library and include any bundled css. There's several `make` commands that make development easier.

`make build`

Builds the project and puts the 'compiled' library in `build`.

`make devserver`

Uses [beefy](http://didact.us/beefy/) to run a development server. As changes are made to the library, they're updated automatically in the development server. You don't need to recompile, beefy takes care of that for you.

`make buildDemoSite` `make demoDeploy`

These two commands build and deploy the [demo site](http://cmcavoy.github.io/openbadges-displayer.js/).