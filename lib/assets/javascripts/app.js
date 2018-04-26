/**
 * Include SCSS files in Build Process
 * @description Use import instead of entry point
 * @see https://github.com/webpack-contrib/extract-text-webpack-plugin/issues/518#issuecomment-304737739
 */
import '../scss/app.scss';

/**
 * Import javascripts
 */
// require('./script.js');
import './script.js';

console.log('Before');
console.log('debounce');
// require('./jquery.stickyheader.js');
require('./jquery.ba-throttle-debounce.js');

console.log('sticky');


console.log('script');

