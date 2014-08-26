# Gulpfile
-----

Does gulp stuff.


Require libs.

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
    pkg = require path.join __dirname, 'package.json'

Set the banner for later use.

    banner = [
        '/*!'
        '<%= pkg.name %> v<%= pkg.version %>'
        ' | @license <%= pkg.license %>'
        '*/'].join ' '
    banner += '\n'

Define the paths

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

## lint
-----

Lint check all coffeescript files.

    gulp.task 'lint', ()->
      return gulp.src(
        path.join path.join '.', 'assets', '**', '*coffee'
      ).pipe(
        coffeelint()
      ).pipe(
        coffeelint.reporter 'fail'
      )

## server_coffee
-----

Compile coffee on server files.

    gulp.task 'server_coffee', ['lint'], ()->
      return gulp.src(
        path.join paths.server.coffee, '*coffee'
      ).pipe(
        coffee()
      ).pipe(
        uglify()
      ).pipe(
        gulp.dest paths.dist.demo
      )

## watch_server
-----

Watch server files for changes

    gulp.task 'watch_server', ()->
      gulp.watch path.join(paths.server.coffee, '*coffee'), ['server_coffee']

## client_coffee
-----

Run gulp-coffee on client files

    gulp.task 'client_coffee', ['less', 'lint'], ()->
      gulp.src(
        path.join paths.client.coffee, '*coffee'
      ).pipe(
        coffee()
      ).pipe(
        browserify {
          transform:['brfs']
        }
      ).pipe(
        uglify()
      ).pipe(
        header banner, { pkg: pkg }
      ).pipe(
        rename 'openbadges-displayer.min.js'
      ).pipe(
        gulp.dest './dist/'
      )

## watch_less
-----

Watch less files

    gulp.task 'watch_less', ()->
      gulp.watch path.join(paths.client.less, '*.less'), ['client_coffee']

## watch_client
-----

Watch client files for changes

    gulp.task 'watch_client', ()->
      gulp.watch path.join(paths.client.coffee, '*coffee'), ['client_coffee']

## copy_templates
-----

Copy templates.

    gulp.task 'copy_templates', ['compile_coffee'], ()->
      # Copy index file
      return gulp.src(
        path.join(paths.client.templates,'index.html')
      ).pipe(
        inlinesource './dist/'
      ).pipe(
        minifyHTML()
      ).pipe(
        gulp.dest(
          paths.public
        )
      )

## copy_images
-----

Copy images.

    gulp.task 'copy_images', ()->
      gulp.src(
        path.join paths.client.images,'*.png'
      ).pipe(
        gulp.dest(
          paths.public
        )
      )

## less
-----

Compile less files.

    gulp.task 'less', () ->
      return gulp.src(
        path.join paths.client.less, '*.less'
      ).pipe(
        less()
      ).pipe(
        base64()
      ).pipe(
        minifyCSS()
      ).pipe(
        header banner, { pkg: pkg }
      ).pipe(
        rename 'openbadges-displayer.min.css'
      ).pipe(
        gulp.dest(
          paths.public_css
        )
      )

## compile_coffee
-----

Compile server and client coffee files.

    gulp.task 'compile_coffee', ['server_coffee', 'client_coffee']

## test
-----

Run test files.

    gulp.task 'test', () ->
      return gulp.src(
        path.join('test', 'test.coffee'), {
          read: false
        }
      ).pipe(
        coffeelint()
      ).pipe(
        coffeelint.reporter 'fail'
      ).pipe(
        coffee()
      ).pipe mocha {reporter: 'nyan'}

## build
-----

Build the app.

    gulp.task 'build', [
      'test'
      'compile_coffee'
      'copy_images'
      'copy_templates'
    ]

## runserver
-----

Run the server.

    gulp.task 'runserver', [
      'build'
      'watch_less'
      'watch_server'
      'watch_client'
    ], ()->
      return gulp.src(
        './dist/demo/server.js'
      ).pipe(
        expressService {
          file: './dist/demo/server.js'
          NODE_ENV: 'DEV'
        }
      )

## default
-----

Calls `runserver`

    gulp.task 'default', ['runserver']

## deploy
-----

Calls `build` then pushes to Github pages.

    gulp.task 'deploy', ['build'], () ->
      gulp.src(
        [
          path.join paths.public, 'index.html'
          path.join paths.public, '*.png'
        ], {
          push:true
        }
      ).pipe(
        deploy cacheDir: paths.deploy_cache
      )
