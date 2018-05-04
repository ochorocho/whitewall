const path = require("path");
const webpack = require("webpack");
const sassLintPlugin = require('sasslint-webpack-plugin');
const UglifyJsPlugin = require('uglifyjs-webpack-plugin');
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const WatchLiveReloadPlugin = require('webpack-watch-livereload-plugin');

const { isProduction } = require('webpack-mode');

console.log(isProduction);

/**
 * Paths for plugin assets
 * @type string
 */
const corePluginBase = './lib/assets/';
const corePluginTarget = (isProduction ? './assets/' : '../../public/plugin_assets/whitewall/');
// const corePluginTarget = './assets/';

/**
 * Define Array and pass it on to webpacks "module.exports.plugins: []" property
 * @type {Array}
 */
let pluginConfig = [];

/**
 * Set output path for SASS compilation
 * @see https://github.com/webpack-contrib/extract-text-webpack-plugin#options
 */
pluginConfig[0] = new ExtractTextPlugin({
    filename: corePluginTarget + 'stylesheets/app.css'
});
const extractPlugin = pluginConfig[0];

/**
 * Lint/Validate sass code
 * @see https://github.com/alleyinteractive/sasslint-webpack-plugin#options
 */
pluginConfig[2] = new sassLintPlugin({
    glob: './scss/**/*.s?(a|c)ss',
    ignoreFiles: [path.resolve(corePluginBase)],
    ignorePlugins: ['extract-text-webpack-plugin']
});

/**
 * Uglify/Minify Javascript based on UglifyJS2
 * @see https://github.com/webpack-contrib/uglifyjs-webpack-plugin#options
 */
pluginConfig[4] = (isProduction ? new UglifyJsPlugin() : '');

/**
 * Reload assets in Browser when changed - Make sure http://localhost:35729/livereload.js included
 * @context Development/Livereload
 * @see https://github.com/napcs/node-livereload#command-line-options
 */
pluginConfig[7] = new WatchLiveReloadPlugin({
    files: [
        // Replace these globs with yours
        corePluginBase + 'scss/**/*.scss',
        corePluginBase + 'javascripts/**/*.js'
    ]
});

/**
 * Remove empty array values - empty values cause webpack plugin config to fail
 * @func pluginConfig
 */
pluginConfig = pluginConfig.filter(function (x) {
    return (x !== (undefined || null || ''));
});

const extractConfig = {
    disable: false,
    fallback: "style-loader",
    use: [
        {
            loader: 'css-loader',
            options: {
                url: false,
                importLoaders: 1,
                minimize: isProduction,
                sourceMap: !isProduction
            }
        },
        {
            loader: 'postcss-loader',
            options: {
                plugins: (loader) => [
                    require('postcss-import')({addDependencyTo: webpack}),
                    require('postcss-url'),
                    require('postcss-cssnext')({
                        browsers: ['last 2 versions', 'ie >= 9'],
                    })
                ]
            }
        },
        {
            loader: "sass-loader",
            options: {
                context: '/',
                includePaths: [
                    path.resolve(corePluginBase + 'scss')
                ]
            }
        }
    ],
};

module.exports = {
    entry: {
        script: [corePluginBase + 'javascripts/app.js'],
    },
    output: {
        path: __dirname,
        filename: corePluginTarget + "javascripts/app.js"
    },
    resolve: {
        extensions: ['.js', '.scss'],
        modules: [
            path.resolve('./node_modules/')
        ],
    },
    watchOptions: {
        ignored: [ /node_modules/]
    },
    module: {
        rules: [{
            test: /\.js$/,
            exclude: [/node_modules/,/jquery.ba-throttle-debounce/],
            enforce: "pre",
            loader: "jshint-loader",
            options: {
                failOnHint: false,
                // Set to true to make sure if it fails build in GitLab will fail as well
                emitErrors: true,
                // reporter: function(errors) { console.log(errors) },
                // Use all options described here: http://jshint.com/docs/options/
                esversion: 6
            }
        }, {
            test: '/\.js$/',
            use: [{
                loader: 'babel-loader',
                options: {
                    presets: ['es2015']
                }
            }]
        }, {
            test: /app\.scss/,
            use: extractPlugin.extract(extractConfig),
        }
        ]
    },
    plugins: pluginConfig
};
