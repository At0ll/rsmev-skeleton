gulp = require 'gulp'
fs = require 'fs'
yaml = require 'js-yaml'
nib = require 'nib'
pngquant = require 'imagemin-pngquant'
gp = {}

Object.keys require('./package.json')['devDependencies']
.filter (pkg) ->
  (pkg.indexOf 'gulp-') is 0
.forEach (pkg) ->
  gp[pkg.replace('gulp-', '').replace(/-/g, '_')] = require pkg

config = yaml.load(fs.readFileSync("config.yml", "utf8"))

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
	gulp.src config.paths.target.main, read: false
		.pipe gp.clean()

gulp.task 'bower', ->
  gp.bower config.paths.bower.main

gulp.task 'lib', ['bower'], ->
  gulp.src [config.paths.bower.angular, config.paths.bower.angularRoute, config.paths.bower.angularMocks]
    .pipe gp.concat config.paths.target.scripts.lib
    .pipe gulp.dest config.paths.target.main
	
gulp.task 'assets', ->
  gulp.src config.paths.assets.fonts
    .pipe gulp.dest config.paths.target.assets.fonts
  gulp.src config.paths.assets.images
    .pipe gulp.dest config.paths.target.assets.images.dest

gulp.task 'deploy', ->
  target = gulp.src config.paths.templates.index
  sources = gulp.src [config.paths.target.scriptsDest.lib, config.paths.target.scriptsDest.admin, config.paths.target.scriptsDest.templates.admin, config.paths.target.assets.styles],
    read: false
  target
    .pipe gp.plumber
      errorHandler: errorHandler
    .pipe gp.inject(sources, name: 'app', ignorePath: "/target/", addRootSlash: false)
    .pipe gulp.dest config.paths.target.main

gulp.task 'admin-coffee', ->
  gulp.src [config.paths.coffee.shared.main, config.paths.coffee.shared.app, config.paths.coffee.admin.main, config.paths.coffee.admin.app]
    .pipe gp.plumber
      errorHandler: errorHandler
    .pipe gp.coffee
      bare: true
    .pipe gp.concat config.paths.target.scripts.admin
    .pipe gulp.dest config.paths.target.main
  gulp.src config.paths.templates.admin
    .pipe gulp.dest config.paths.target.main

gulp.task 'client-coffee', ->
  gulp.src [config.paths.coffee.shared.main, config.paths.coffee.shared.app, config.paths.coffee.client.main, config.paths.coffee.client.app]
    .pipe gp.plumber
      errorHandler: errorHandler
    .pipe gp.coffee
      bare: true
    .pipe gp.concat config.paths.target.scripts.client
    .pipe gulp.dest config.paths.target.main
  gulp.src config.paths.templates.client
    .pipe gulp.dest config.paths.target.main

gulp.task 'stylus', ->
  gulp.src config.paths.assets.styles
    .pipe gp.plumber
      errorHandler: errorHandler
    .pipe gp.stylus
      whitespace: true
      compress: true
      use: [nib()]
      import: 'nib'
    .pipe gulp.dest config.paths.target.main

gulp.task 'templates-admin', ->
  gulp.src [config.paths.templates.index, config.paths.templates.admin]
    .pipe gp.plumber
      errorHandler: errorHandler
    .pipe gp.angular_templatecache filename: config.paths.target.scripts.templates.admin
    .pipe gulp.dest config.paths.target.main

gulp.task 'templates-client', ->
  gulp.src [config.paths.templates.index, config.paths.templates.client]
  .pipe gp.plumber
    errorHandler: errorHandler
  .pipe gp.angular_templatecache filename: config.paths.target.scripts.templates.client
  .pipe gulp.dest config.paths.target.main
  
gulp.task 'test-admin', ->
  gulp.src [config.paths.target.scriptsDest.lib, config.paths.target.scriptsDest.admin, config.paths.test.admin]
  .pipe gp.karma
    configFile: config.paths.karma.file,
    action: 'run'

gulp.task 'test-client', ->
  gulp.src [config.paths.target.scriptsDest.lib, config.paths.target.scriptsDest.client, config.paths.test.client]
  .pipe gp.karma
    configFile: config.paths.karma.file,
    action: 'run'

###
  Optimization tasks
###
gulp.task 'jshint', ['admin-coffee', 'client-coffee', 'templates-admin', 'templates-client'], ->
  gulp.src [config.paths.target.scriptsDest.admin, config.paths.target.scriptsDest.client, config.paths.target.scriptsDest.templates.admin, config.paths.target.scriptsDest.templates.client]
    .pipe gp.jshint()
    .pipe gp.jshint.reporter 'default'

gulp.task 'scripts-min', ->
  gulp.src config.paths.target.scriptsDest.all
    .pipe gp.plumber
      errorHandler: errorHandler
    .pipe gp.uglify()
    .pipe gulp.dest config.paths.target.main

gulp.task 'image-min', ->
  gulp.src config.paths.target.assets.images.all
    .pipe gp.plumber
      errorHandler: errorHandler
    .pipe gp.imagemin
      progressive: true
      svgoPlugins: [removeViewBox: false]
      use: [pngquant()]
    .pipe gulp.dest config.paths.target.assets.images.dest

###
  Gulp watch tasks
###
gulp.task 'watch', ->
  gulp.watch [config.paths.coffee.admin.main, config.paths.coffee.admin.app],  ['admin-coffee']
  gulp.watch [config.paths.coffee.client.main, config.paths.coffee.client.app], ['client-coffee']
  gulp.watch [config.paths.coffee.shared.main, config.paths.coffee.shared.app], ['admin-coffee', 'client-coffee']
  gulp.watch config.paths.assets.styles, ['stylus']

###
Gulp group tasks
###
gulp.task 'build', ['clean', 'bower', 'lib']
gulp.task 'test', ['test-admin', 'test-client']
gulp.task 'minify', ['scripts-min', 'image-min']

gulp.task 'default', ['assets', 'admin-coffee', 'client-coffee', 'stylus', 'templates-admin', 'templates-client'], ->
  gulp.start 'deploy'

gulp.task 'dev', ['default', 'watch']

gulp.task 'prod', ['default'], ->
  gulp.start 'minify'
	 
