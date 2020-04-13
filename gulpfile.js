'use strict';

var gulp = require('gulp');
var vapor = require('gulp-vapor');

gulp.task('vapor:start', vapor.start)
gulp.task('vapor:reload', vapor.reload);

gulp.task('watch', function() {
    gulp.watch('./Sources/**/*', gulp.series('vapor:reload'));
});

gulp.task('default', gulp.series('vapor:start', 'watch'))