var gulp  = require('gulp');
var babelify = require('babelify');
var browserify = require('browserify');
var source = require('vinyl-source-stream');

gulp.task('build', function() {
  return browserify({
    entries: ['client/app.js'],
    extensions: ['js']
  })
  .transform(babelify)
  .bundle()
  .pipe(source('bundle.js'))
  .pipe(gulp.dest('priv/static/js'))
});

gulp.task('watch', function() {
  gulp.watch('client/**/*.js', ['build'])
});

gulp.task('default', ['build', 'watch']);
