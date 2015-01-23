gulp = require 'gulp'
gp = {}
Object.keys require('./package.json')['devDependencies']
.filter (pkg) ->
  (pkg.indexOf 'gulp-') is 0
.forEach (pkg) ->
  gp[pkg.replace('gulp-', '').replace(/-/g, '_')] = require pkg

###
  Error handler
###
errorHandler = (err) ->
  console.log "[" + err.name + " in " + err.plugin + "]", err.message
  @end

###
  Gulp tasks
###
gulp.task 'clean', ->
  gulp.src './target', {read: false}
  .pipe gp.clean()

gulp.task 'bower', ->
  gp.bower './bower_components'

gulp.task 'lib', ['bower'], ->
  gulp.src ['./bower_components/angular/angular.js', './bower_components/angular-route/angular-route.js', './bower_components/angular-mocks/angular-mocks.js']
  .pipe gp.concat 'lib.js'
  .pipe gulp.dest './target'

gulp.task 'deploy', ->
  gulp.src './src/index.html'
  .pipe gulp.dest './target/'

gulp.task 'admin-coffee', ->
  gulp.src ['./src/shared/*.coffee', './src/shared/app/*.coffee', './src/admin/*.coffee', './src/admin/app/*.coffee']
  .pipe gp.plumber
    errorHandler: errorHandler
  .pipe gp.coffee
    bare: true
  .pipe gp.concat 'admin-app.js'
  .pipe gulp.dest './target'
  gulp.src './src/admin/partials/**'
  .pipe gulp.dest './target'

gulp.task 'client-coffee', ->
  gulp.src ['./src/shared/*.coffee', './src/shared/app/*.coffee', './src/client/*.coffee', './src/client/app/*.coffee']
  .pipe gp.plumber
    errorHandler: errorHandler
  .pipe gp.coffee
    bare: true
  .pipe gp.concat 'client-app.js'
  .pipe gulp.dest './target'
  gulp.src './src/client/partials/**'
  .pipe gulp.dest './target'

gulp.task 'test-admin', ->
  gulp.src ['target/lib.js', 'target/admin-app.js', 'test/admin/*.spec.coffee']
  .pipe gp.karma {
    configFile: 'karma.conf.js',
    action: 'run'
  }

gulp.task 'test-client', ->
  gulp.src ['target/lib.js', 'target/client-app.js', 'test/client/*.spec.coffee']
  .pipe gp.karma {
    configFile: 'karma.conf.js',
    action: 'run'
  }

###
  Gulp watch tasks
###
gulp.task 'watch', ->
  gulp.watch './src/admin/', ['admin-coffee']
  gulp.watch './src/client/', ['client-coffee']
  gulp.watch './src/shared/', ['admin-coffee', 'client-coffee']

###
Gulp group tasks
###
gulp.task 'build', ['clean', 'bower', 'lib']
gulp.task 'test', ['test-admin', 'test-client']
gulp.task 'default', ['deploy', 'admin-coffee', 'client-coffee']
	 
