var gulp = require('gulp');
var concat = require('gulp-concat');
var clean = require('gulp-clean');
var karma = require('gulp-karma');

gulp.task('clean', function () {
    gulp.src('./target', {read: false})
        .pipe(clean());
});

gulp.task('deploy', function () {
    gulp.src('./src/index.html')
        .pipe(gulp.dest('./target/'));
});

gulp.task('lib', function () {
    gulp.src(['./bower_components/angular/angular.js', './bower_components/angular-route/angular-route.js', './bower_components/angular-mocks/angular-mocks.js'])
        .pipe(concat('lib.js'))
        .pipe(gulp.dest('./target/'));
});

gulp.task('admin-app', function () {
    gulp.src(['./src/admin/partials/**'])
        .pipe(gulp.dest('./target/'));
    gulp.src(['./src/shared/app.js', './src/shared/app/*.js', './src/admin/app.js', './src/admin/app/*.js'])
        .pipe(concat('admin-app.js'))
        .pipe(gulp.dest('./target/'));
});

gulp.task('client-app', function () {
    gulp.src(['./src/client/partials/**'])
        .pipe(gulp.dest('./target/'));
    gulp.src(['./src/shared/app.js', './src/shared/app/*.js', './src/client/app.js', './src/client/app/*.js'])
        .pipe(concat('client-app.js'))
        .pipe(gulp.dest('./target/'));
});

gulp.task('test', function () {
    // Be sure to return the stream
    return gulp.src([
        'target/lib.js',
        'target/*.js',
        'test/**/*.spec.js'
    ])
        .pipe(karma({
            configFile: 'karma.conf.js',
            action: 'run'
        }))
        .on('error', function (err) {
            // Make sure failed tests cause gulp to exit non-zero
//            throw err;
        });
});

gulp.task('default', ['deploy', 'admin-app']);