# Gulpfile
-----

Controls important operations such as compiling openbadges-displayer.js and
running the server.

Run gulp tasks from the command line.

`gulp` runs the default task.

`gulp *task name*` runs an individual task

**Example:** `gulp build`

## Setup
-----

Require libs and define paths.

    # Require various libraries.
    gulp = require 'gulp'
    expressService = require 'gulp-express-service'
    coffee = require 'gulp-coffee'
    path = require 'path'
    browserify = require 'gulp-browserify'
    uglify = require 'gulp-uglify'
    minifyCSS = require 'gulp-minify-css'
    rename = require 'gulp-rename'
    less = require 'gulp-less'
    base64 = require 'gulp-base64'
    minifyHTML = require 'gulp-minify-html'
    header = require 'gulp-header'
    coffeelint = require 'gulp-coffeelint'
    mocha = require 'gulp-mocha'
    deploy = require 'gulp-gh-pages'
    inlinesource = require 'gulp-inline-source'
    clean = require 'gulp-clean'
    runSequence = require 'run-sequence'
    pkg = require path.join __dirname, 'package.json'

    # Define paths.
    assets = path.join '.', 'assets'
    clientAssets = path.join assets, 'demo', 'client'
    serverAssets = path.join assets, 'demo', 'server'
    paths =
      client:
        css:path.join clientAssets, 'css'
        coffee:path.join 'assets', 'src'
        less:path.join 'assets', 'src'
        templates:path.join clientAssets, 'templates'
        images:path.join clientAssets, 'imgs'
      vendor:path.join assets, 'vendor'
      server:coffee:path.join serverAssets
      dist:demo:path.join 'dist', 'demo'
      public: path.join 'dist', 'demo', 'public'
      public_css: path.join 'dist'
      public_images: path.join 'dist', 'demo', 'imgs'
      compiled_js: path.join 'dist', 'js'
      public_js: path.join 'dist', 'demo', 'public', 'js'
      temp: 'temp'
      deploy_cache: 'deploy_cache'
      src: path.join assets, 'src'

Create banner for later use. This banner will be included at the top of compiled
CSS and JS pages.

    banner = [
        '/*!'
        '<%= pkg.name %> v<%= pkg.version %>'
        ' | @license <%= pkg.license %>'
        '*/'].join ' ' + '\n'

## Tasks
-----

Here we define the gulp tasks which will build our compiled library and demo.

### Main library tasks

These tasks will help us build the main library.

#### build_main

Builds the following files

  * __openbadges-displayer.js/dist/openbadges-displayer.min.js__
  * __openbadges-displayer.js/dist/openbadges-displayer.min.css__

Compile coffeescript, and test the resulting JS file.


    gulp.task 'build_main', ()->
      return gulp.src path.join paths.client.coffee, '*coffee'
      .pipe coffee()
      .pipe browserify { transform:['brfs'] }
      .pipe uglify()
      .pipe header banner, { pkg: pkg }
      .pipe rename 'openbadges-displayer.min.js'
      .pipe gulp.dest './dist/'
      

#### build_demo

Build the demo.

  * __openbadges-displayer.js/dist/demo/__ 

The demo is compiled from the `assets/demo` directory.

    gulp.task 'build_demo', ()->
      return gulp.src path.join(paths.server.coffee, '*coffee')
      .pipe coffee()
      .pipe uglify()
      .pipe gulp.dest paths.dist.demo

### deploy_demo

Builds the demo, then pushes to Github pages.

    gulp.task 'deploy_demo', ['build_demo'], () ->
      return gulp.src [
          path.join paths.public, 'index.html'
          path.join paths.public, '*.png'
        ], { push:true }
      .pipe deploy cacheDir: paths.deploy_cache

#### copy_templates

Copy templates to dist directory.

    gulp.task 'copy_templates', ()->
      return gulp.src path.join(paths.client.templates, 'index.html')
      .pipe inlinesource './dist/'
      .pipe minifyHTML()
      .pipe gulp.dest paths.public

#### copy_images

Copy images to dist directory.

    gulp.task 'copy_images', ()->
      return gulp.src path.join paths.client.images, '*.png'
      .pipe gulp.dest paths.public

#### less

Compile less to CSS.

    gulp.task 'less', () ->
      return gulp.src path.join paths.client.less, '*.less'
      .pipe less()
      .pipe base64()
      .pipe minifyCSS()
      .pipe header banner, { pkg: pkg }
      .pipe rename 'openbadges-displayer.min.css'
      .pipe gulp.dest paths.public_css

### General tasks

#### lint

Lint check all coffeescript files.

    gulp.task 'lint', ()->
      return gulp.src path.join '.', 'assets', '**', '*coffee'
      .pipe coffeelint()
      .pipe coffeelint.reporter 'fail'

#### test

Run test files.

    gulp.task 'test', () ->
      return gulp.src path.join('test', 'test.litcoffee'), read: false
      .pipe coffeelint()
      .pipe coffeelint.reporter 'fail'
      .pipe coffee()
      .pipe mocha {reporter: 'nyan'} # Nyancat powers activate!

#### run_server

Run the server.

    gulp.task 'run_server', ()->
      return gulp.src './dist/demo/server.js'
       .pipe expressService file: './dist/demo/server.js', NODE_ENV: 'DEV'

#### clean

Removes the dist directory for a clean build.

    gulp.task 'clean', ()->
      return gulp.src 'dist', {read:false}
        .pipe clean()


#### default

Builds the library and demo, and runs the server.

    gulp.task 'default', ()->
      runSequence(
        'clean'
        'less'
        'lint'
        'build_main'
        'copy_templates'
        'copy_images'
        'build_demo'
        'test'
        'run_server'
      )