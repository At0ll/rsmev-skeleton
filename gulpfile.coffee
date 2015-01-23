gulp = require 'gulp'
fs = require 'fs'
yaml = require 'js-yaml'
gp = {}

Object.keys require('./package.json')['devDependencies']
  .filter (pkg) -> pkg.indexOf 'gulp-' is 0
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
	gulp.src config.paths.target.main, {read: false}
		.pipe gp.clean()

gulp.task 'bower', ->
  gp.bower config.paths.bower.main

gulp.task 'lib', ['bower'], ->
  gulp.src [config.paths.bower.angular, config.paths.bower.angularRoute]
  .pipe gp.concat 'lib.js'
  .pipe gulp.dest config.paths.target.main
	
gulp.task 'deploy', ->
	gulp.src config.paths.templates.index
		.pipe gulp.dest './target/'

gulp.task 'admin-coffee', ->
  gulp.src [config.paths.coffee.admin.main, config.paths.coffee.admin.app, config.paths.coffee.shared.main, config.paths.coffee.shared.app]
    .pipe gp.plumber
      errorHandler: errorHandler
    .pipe gp.coffee
      bare: true
    .pipe gp.concat config.paths.target.scripts.admin
    .pipe gulp.dest config.paths.target.main
  gulp.src config.paths.templates.admin
    .pipe gulp.dest config.paths.target.main


gulp.task 'client-coffee', ->
  gulp.src [config.paths.coffee.client.main, config.paths.coffee.client.app, config.paths.coffee.shared.main, config.paths.coffee.shared.app]
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
    .pipe gp.styl()
    .pipe gulp.dest config.paths.target.main
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
gulp.task 'default', ['deploy', 'admin-coffee', 'client-coffee', 'stylus']
	 
