/**
 * Include SCSS files in Build Process
 * @description Use import instead of entry point
 * @see https://github.com/webpack-contrib/extract-text-webpack-plugin/issues/518#issuecomment-304737739
 */
import '../scss/app.scss';

/**
 * Import javascripts
 */
import './jquery.ba-throttle-debounce.js';
import './jquery.stickyheader.js';
import './script.js';
