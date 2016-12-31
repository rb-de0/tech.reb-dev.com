'use strict';

var gulp = require('gulp');
var vapor = require('gulp-vapor');

vapor.config.commands.build = 'swift build -Xswiftc -I/usr/local/include/mysql -Xswiftc -I/usr/local/include -Xlinker -L/usr/local/lib'; // #1
vapor.config.commands.start = ['.build/debug/App']

gulp.task('vapor:start', vapor.start);
gulp.task('vapor:reload', vapor.reload);

gulp.task('watch', function() {
    // #2
    var target = [
        './Sources/**/*',
        './Resources/**/*',
        './Public/**/*'
    ];
    gulp.watch(target, ['vapor:reload']);
});

gulp.task('default', ['vapor:start', 'watch']);
