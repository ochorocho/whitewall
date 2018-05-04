/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// define __esModule on exports
/******/ 	__webpack_require__.r = function(exports) {
/******/ 		Object.defineProperty(exports, '__esModule', { value: true });
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 0);
/******/ })
/************************************************************************/
/******/ ({

/***/ "./lib/assets/javascripts/app.js":
/*!***************************************!*\
  !*** ./lib/assets/javascripts/app.js ***!
  \***************************************/
/*! no exports provided */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
eval("__webpack_require__.r(__webpack_exports__);\n/* harmony import */ var _scss_app_scss__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../scss/app.scss */ \"./lib/assets/scss/app.scss\");\n/* harmony import */ var _scss_app_scss__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(_scss_app_scss__WEBPACK_IMPORTED_MODULE_0__);\n/* harmony import */ var _script_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./script.js */ \"./lib/assets/javascripts/script.js\");\n/* harmony import */ var _script_js__WEBPACK_IMPORTED_MODULE_1___default = /*#__PURE__*/__webpack_require__.n(_script_js__WEBPACK_IMPORTED_MODULE_1__);\n/**\n * Include SCSS files in Build Process\n * @description Use import instead of entry point\n * @see https://github.com/webpack-contrib/extract-text-webpack-plugin/issues/518#issuecomment-304737739\n */\n\n\n/**\n * Import javascripts\n */\n\n\n\n//# sourceURL=webpack:///./lib/assets/javascripts/app.js?");

/***/ }),

/***/ "./lib/assets/javascripts/script.js":
/*!******************************************!*\
  !*** ./lib/assets/javascripts/script.js ***!
  \******************************************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("$(function() {\n    // NO RELATION ISSUES\n    $('#whitewall-equal-assignee-editor').click(function () {\n       var assignee = $('#issue_assigned_to_id').val();\n       console.log(assignee);\n    });\n\n\n\t$('#noRel').click(function() {\n\n        $.ajax({\n            dataType: \"html\",\n            url: \"/whitewall/ajax/norelation\",\n            data: \"\",\n            success: function(data) {\n                $(\"#relDialog\").html(data).dialog({\n                    height: 400,\n                    width: \"80%\",\n                    minWidth: 540,\n                    minHeight: 200,\n                    modal: true,\n                    maxWidth: 1280,\n                    maxHeight: 1000\n                });\n            },\n            error: function() {\n                alert('Error: Please reload!');\n            }\n        });\n\t});\n\n\t// SHOW/HIDE DETAILS\n\t$('#showDetails').click(function() {\n\t\tif($(this).hasClass('open')) {\n        \t$(this).removeClass('open');\n            $('.postIt').find('.hidden').slideToggle(200);\n\t\t} else {\n        \t$(this).addClass('open');\n\t\t\t$('.postIt').find('.hidden').slideToggle(200);\n\t\t}\n\t});\n\n\t$('.hidden').hide(0);\n\n    $(\".postIt\").click(function(e){\n        if($(e.target).is('.sort-handle')){\n            e.preventDefault();\n            return;\n        } else {\n            if($(this).hasClass('open')) {\n                $(this).removeClass('open');\n                $(this).find('.hidden').slideToggle(200);\n            } else {\n                $(this).addClass('open');\n                $(this).find('.hidden').slideToggle(200);\n            }\n\t\t}\n    });\n\n\t$('#showDisplay').on({\n\t    'click': function() {\n            $(\"#displayDialog\").dialog({\n                height: 400,\n                width: 540,\n\t\t\t\tmodal: true,\n                minWidth: 540,\n                minHeight: 200,\n                maxWidth: 1280,\n                maxHeight: 1000,\n                show: {\n                    effect: \"fade\",\n                    duration: 200\n                },\n                hide: {\n                    effect: \"explode\",\n                    duration: 800\n                },\n                buttons: {\n                    Cancel: function() {\n                        dialog.dialog( \"close\" );\n                    },\n                    \"apply\": function () {\n                        $('#displayForm').submit();\n                    }\n                },\n            });\n\t    }\n\t});\n\t$('#displayDialog .invert b').click(function() {\n\t\t$('#displayDialog li input[type=checkbox]').each(function() {\n            $(this).click();\n\t\t});\n\t});\n\n\t$('.tracker').click(function() {\n\t\tvar trackerId = $(this).attr('id');\n        $(this).toggleClass('open');\n        $('.' + trackerId).slideToggle(200,function () {\n            $(window).trigger('resize');\n        });\n\t});\n\n    $( function() {\n        $( \"#scroll tbody td\" ).sortable({\n            connectWith: \".sortItCon\",\n            placeholder: \"ui-state-highlight\",\n            handle: \".sort-handle\",\n            update: function(e,ui) {\n                if (this === ui.item.parent()[0]) {\n                    $(window).trigger('resize');\n                }\n            }\n        }).disableSelection();\n    } );\n\n    $(function() {\n        $( \".weeklyGraph\" ).each(function () {\n\n            var pv = $(this).data(\"progress-value\"),\n                pm = $(this).data(\"progress-max\");\n\n            var bar = $(this).attr('data-value');\n            $(this).progressbar({\n                value: pv,\n                max: pm,\n            });\n        });\n    });\n\n});\n\n//# sourceURL=webpack:///./lib/assets/javascripts/script.js?");

/***/ }),

/***/ "./lib/assets/scss/app.scss":
/*!**********************************!*\
  !*** ./lib/assets/scss/app.scss ***!
  \**********************************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("// removed by extract-text-webpack-plugin\n\n//# sourceURL=webpack:///./lib/assets/scss/app.scss?");

/***/ }),

/***/ 0:
/*!*********************************************!*\
  !*** multi ./lib/assets/javascripts/app.js ***!
  \*********************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("module.exports = __webpack_require__(/*! ./lib/assets/javascripts/app.js */\"./lib/assets/javascripts/app.js\");\n\n\n//# sourceURL=webpack:///multi_./lib/assets/javascripts/app.js?");

/***/ })

/******/ });