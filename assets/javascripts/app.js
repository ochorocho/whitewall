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
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports, __webpack_require__) {

module.exports = __webpack_require__(1);


/***/ }),
/* 1 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__scss_app_scss__ = __webpack_require__(2);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__scss_app_scss___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_0__scss_app_scss__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__script_js__ = __webpack_require__(3);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__script_js___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_1__script_js__);
/**
 * Include SCSS files in Build Process
 * @description Use import instead of entry point
 * @see https://github.com/webpack-contrib/extract-text-webpack-plugin/issues/518#issuecomment-304737739
 */


/**
 * Import javascripts
 */



/***/ }),
/* 2 */
/***/ (function(module, exports) {

// removed by extract-text-webpack-plugin

/***/ }),
/* 3 */
/***/ (function(module, exports) {

$(function() {
    // NO RELATION ISSUES
    console.log('script javscript');
	$('#noRel').click(function() {

        $.ajax({
            dataType: "html",
            url: "/whitewall/ajax/norelation",
            data: "",
            success: function(data) {
                $("#relDialog").html(data).dialog({
                    height: 400,
                    width: "80%",
                    minWidth: 540,
                    minHeight: 200,
                    modal: true,
                    maxWidth: 1280,
                    maxHeight: 1000
                });
            },
            error: function() {
                alert('Error: Please reload!');
            }
        });
	});

	// SHOW/HIDE DETAILS
	$('#showDetails').click(function() {
		if($(this).hasClass('open')) {
        	$(this).removeClass('open');
            $('.postIt').find('.hidden').slideToggle(200);
		} else {
        	$(this).addClass('open');
			$('.postIt').find('.hidden').slideToggle(200);
		}
	});

	$('.hidden').hide(0);

    $(".postIt").click(function(e){
        if($(e.target).is('.sort-handle')){
            e.preventDefault();
            return;
        } else {
            if($(this).hasClass('open')) {
                $(this).removeClass('open');
                $(this).find('.hidden').slideToggle(200);
            } else {
                $(this).addClass('open');
                $(this).find('.hidden').slideToggle(200);
            }
		}
    });

	$('#showDisplay').on({
	    'click': function() {
            $("#displayDialog").dialog({
                height: 400,
                width: 540,
				modal: true,
                minWidth: 540,
                minHeight: 200,
                maxWidth: 1280,
                maxHeight: 1000,
                show: {
                    effect: "fade",
                    duration: 200
                },
                hide: {
                    effect: "explode",
                    duration: 800
                },
                buttons: {
                    Cancel: function() {
                        dialog.dialog( "close" );
                    },
                    "apply": function () {
                        $('#displayForm').submit();
                    }
                },
            });
	    }
	});
	$('#displayDialog .invert b').click(function() {
		$('#displayDialog li input[type=checkbox]').each(function() {
            $(this).click();
		});
	});

	$('.tracker').click(function() {
		var trackerId = $(this).attr('id');
        $(this).toggleClass('open');
        $('.' + trackerId).slideToggle(200,function () {
            $(window).trigger('resize');
        });
	});

    $( function() {
        $( "#scroll tbody td" ).sortable({
            connectWith: ".sortItCon",
            placeholder: "ui-state-highlight",
            handle: ".sort-handle",
            update: function(e,ui) {
                if (this === ui.item.parent()[0]) {
                    $(window).trigger('resize');
                }
            }
        }).disableSelection();
    } );

    $(function() {
        $( ".weeklyGraph" ).each(function () {

            var pv = $(this).data("progress-value"),
                pm = $(this).data("progress-max");

            var bar = $(this).attr('data-value');
            $(this).progressbar({
                value: pv,
                max: pm,
            });
        });
    });

});

/***/ })
/******/ ]);