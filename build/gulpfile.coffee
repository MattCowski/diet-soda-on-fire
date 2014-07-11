gulp = require 'gulp'
# parameters    = require '../config/parameters.coffee'

coffee  = require 'gulp-coffee'
concat  = require 'gulp-concat'
filter = require 'gulp-filter'
gutil   = require 'gulp-util'
jade    = require 'gulp-jade'
bowerFiles    = require 'gulp-bower-files'
templateCache      = require 'gulp-angular-templatecache'
serve = require 'gulp-serve'
livereload = require 'gulp-livereload'
browserSync = require 'browser-sync'
reload = browserSync.reload

app_path = 'app'
parameters = 
  config =
    app_path: app_path
    web_path: ' public'
    vendor_path: 'vendor'
    assets_path: app_path + '/assets'
    app_main_file: 'app.js'
    css_main_file: 'app.css'
    styles_main_file: app_path + '/app.less' # or app.sass
    templates_file: 'app.templates.js'
    templates_module: 'myapp'
    vendor_main_file: 'vendor.js'
    bower_main_file: 'bower-vendor.js'
    manifest_file: 'myapp.appcache'

# module.exports = config

gulp.task 'coffee', ->
  gulp.src parameters.app_path+'/**/*.coffee'
  .pipe coffee bare: true
  .pipe concat parameters.app_main_file
  .pipe gulp.dest parameters.web_path+'/js'
  .on 'error', gutil.log

gulp.task 'jade', ->
  gulp.src parameters.app_path + '/*.jade'
  .pipe jade pretty: true
  .pipe gulp.dest parameters.web_path
  .on 'error', gutil.log

gulp.task 'bower', ->
  # bowerFiles()
  bowerFiles({
    paths: {
        bowerDirectory: 'app/bower_components',
        # bowerrc: '../',
        bowerJson: ''
    }
  })
  .pipe filter '**/*.js'
  .pipe concat parameters.bower_main_file
  .pipe gulp.dest parameters.web_path+'/js'
  .on 'error', gutil.log

gulp.task 'templates', ->
  gulp.src parameters.app_path + '/*/**/*.jade' # All jades inside modules (not the main index.jade file!)
  .pipe jade doctype: 'html'
  .pipe templateCache
    filename: parameters.templates_file
    module: parameters.templates_module
    standalone: false # True if you want it to be a separate module
  .pipe gulp.dest parameters.web_path + '/js'
  .on 'error', gutil.log


gulp.task 'watch',
# ['build'], # After all build tasks are done
->
  browserSync
    notify: false
    server:
      baseDir: './_public'
  gulp.watch parameters.app_path + '/**/*.coffee', ['coffee', reload]
  # gulp.watch parameters.app_path + '/**/*.(less|saas)', ['styles', 'manifest', 'references'] # Manifest and references task is necessary if these files are versioned
  gulp.watch parameters.app_path + '/*.jade', ['jade', reload] # References task only for files that contain references (but are not versioned, typically index.(jade|html))
  gulp.watch parameters.app_path + '/*/**/*.jade', ['templates', reload]
  # gulp.watch parameters.app_path + '/*/**/*.html', ['htmlTemplates', reload]
  # gulp.watch parameters.assets_path, ['assets']
  gulp.watch 'bower.json', ['bower']