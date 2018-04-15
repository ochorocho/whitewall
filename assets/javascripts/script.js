$(function() {
    // NO RELATION ISSUES
	$('#noRel').click(function() {
		$("#relDialog").dialog({
			height: 400,
			width: 540,
			minWidth: 540,
			minHeight: 200,
			modal: true,
			maxWidth: 1280,
			maxHeight: 1000,
			show: {
				effect: "fade",
				duration: 200
			},
			hide: {
				effect: "explode",
				duration: 800
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