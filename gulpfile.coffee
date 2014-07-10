gulp = require 'gulp'
expressService = require 'gulp-express-service'
coffee = require 'gulp-coffee'
path = require 'path'
browserify = require 'gulp-browserify'
uglify = require 'gulp-uglify'
rename = require 'gulp-rename'
less = require 'gulp-less'
minified_filename = 'openbadges-displayer.min.js'


# Define paths
assets = path.join '.', 'assets'
clientAssets = path.join assets, 'client'
serverAssets = path.join assets, 'server'

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
  public_css: path.join 'dist', 'css'
  public_images: path.join 'dist', 'imgs'
  compiled_js: path.join 'dist', 'js'
  public_js: path.join 'dist', 'demo', 'public', 'js'
  temp: 'temp'

# run gulp-coffee on server files
gulp.task 'server_coffee', ()->
  return gulp.src(
    path.join paths.server.coffee, '*.coffee'
  ).pipe(
    coffee()
  ).pipe(
    gulp.dest paths.dist.demo
  )

# watch server files for changes
gulp.task 'watch_server', ()->
  gulp.watch path.join(paths.server.coffee, '*.coffee'), ['server_coffee']

# run gulp-coffee on client files
gulp.task 'client_coffee', ()->
  return gulp.src(
    path.join paths.client.coffee, '*.coffee'
  ).pipe(
    coffee()
  ).pipe(
    browserify()
  ).pipe(
    uglify()
  ).pipe(
    rename 'openbadges-displayer.min.js'
  ).pipe(
    gulp.dest './dist'
  )

# watch less files
gulp.task 'watch_less', ()->
  gulp.watch path.join(paths.client.less, '*.less'), ['less']

# watch client files for changes
gulp.task 'watch_client', ()->
  gulp.watch path.join(paths.client.coffee, '*.coffee'), ['client_coffee']

# copy templates
gulp.task 'copy_templates', ()->
  # Copy index file
  return gulp.src(
    path.join paths.client.templates,'index.html'
  ).pipe(
    gulp.dest(
      paths.public
    )
  )

# copy images
gulp.task 'copy_images', ()->
  return gulp.src(
    path.join paths.client.images,'*.png'
  ).pipe(
    gulp.dest(
      paths.public_images
    )
  )

# less
gulp.task 'less', () ->
  gulp.src(
    path.join paths.client.less, '*.less'
  ).pipe(
    less()
  ).pipe(
    gulp.dest(
      paths.public_css
    )
  )

gulp.task 'compile_coffee', ['server_coffee', 'client_coffee']

gulp.task 'runserver', ['compile_coffee', 'copy_templates', 'less', 'copy_images', 'watch_less', 'watch_server', 'watch_client'], ()->
  return gulp.src(
    './dist/demo/server.js'
  ).pipe(
    expressService({
      file: './dist/demo/server.js',
      NODE_ENV: 'DEV'
    })
  )

gulp.task 'default', ['runserver']