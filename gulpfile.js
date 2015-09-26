var gulp       = require('gulp');
var babelify   = require('babelify');
var browserify = require('browserify');
var source     = require('vinyl-source-stream');
var sass       = require('gulp-ruby-sass');
var plumber    = require('gulp-plumber');
var pleeease   = require('gulp-pleeease');
var concat     = require('gulp-concat');

gulp.task('build', function() {
  return browserify({entries: ['client/app.js'], extensions: ['js']})
    .transform(babelify)
    .bundle()
    .pipe(source('bundle.js'))
    .pipe(gulp.dest('priv/static/js'))
});

gulp.task('sass', function() {
  sass('client/stylesheets/*.scss', {style: 'expanded'})
    .pipe(plumber())
    .pipe(pleeease({
      autoprefixer: {
        browsers: ['last 2 versions']
      },
      minifier: false
    }))
    .pipe(concat('app.css'))
    .pipe(gulp.dest('priv/static/css/'))
});

gulp.task('watch', function() {
  gulp.watch('client/**/*.js', ['build'])
  gulp.watch('client/stylesheets/*.scss', ['sass'])
});

gulp.task('default', ['build', 'sass', 'watch']);
