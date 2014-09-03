# ![Logo](assets/src/badgelogo.png) Open Badges Displayer
-----

A Javascript client library for easily displaying meta-information about
baked open badges.

## Demo
-----

[https://curlee.github.io/openbadges-displayer.js/](https://curlee.github.io/openbadges-displayer.js/)

## Usage
-----

`bower install git@github.com:cmcavoy/openbadges-displayer.js.git`

[Download the latest release.](https://github.com/cmcavoy/openbadges-displayer.js/releases)

Insert openbadges-displayer.js at the bottom of your web page that contains
badges.

    <script type="text/javascript" src="openbadges-displayer.min.js" ></script>

### Unbake (display) badges

    <script type="text/javascript">
      window.openbadges.unbake([options]);
    </script>

Badges will be unbaked and included in `window.openbadges.badges` which you can
explore in the browser console.

Additionally, a lightbox will be added to the page. Partial badge info will be
displayed when rolling over the badge, and full info will be displayed in the
lightbox after clicking a badge.

## Development
-----

`openbadges-displayer.js` is under active development. To help out, fork this
library and submit pull requests with new features. Get started by picking up an
[issue](http://github.com/cmcavoy/openbadges-displayer.js/issues), or filing
[bug](http://github.com/cmcavoy/openbadges-displayer.js/issues).

### Requirements

[Node v0.10.29](http://nodejs.org/)

### Installation

After cloning this repo:

`npm start`

This will install requirements and then use gulp to compile the code and
run the server. Requirements will only install once (unless they change).

### Gulp

openbadges-displayer.js uses Gulp. For available commands, take a look at
[gulpfile.litcoffee](gulpfile.litcoffee)

### Viewing the demo

After compiling and running the demo server (`npm start` or `gulp`) go to:

[http://localhost:3000](http://localhost:3000)

### Testing

`gulp test` or `npm test`

Tests are written using coffeescript and are run with gulp-mocha.

## Future
-----

### Add more tests

Need more test coverage.