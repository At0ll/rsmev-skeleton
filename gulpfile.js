var gulp = require('gulp');
var concat = require('gulp-concat');
var clean = require('gulp-clean');

gulp.task('clean', function () {
    gulp.src('./target', {read: false})
        .pipe(clean());
});

gulp.task('deploy', function () {
    gulp.src('./src/index.html')
        .pipe(gulp.dest('./target/'));
});

gulp.task('lib', function () {
    gulp.src(['./bower_components/angular/angular.js', './bower_components/angular-route/angular-route.js'])
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

gulp.task('default', ['deploy', 'admin-app', 'client-app']);