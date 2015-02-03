$(function() {
	$('#timespan form').submit(function(e) {

		if($('#from').length) {
			var from = $('#from');
			if(Date.parse(from.val())) {
				$(from).removeClass('error');
			} else {
				$(from).addClass('error');
				e.preventDefault();
			}			
		}

		var to = $('#to');
		if(Date.parse(to.val())) {
			$(to).removeClass('error');
		} else {
			$(to).addClass('error');
			e.preventDefault();
		}
	});

	// DATEPICKER - TIMESPAN
	$("#from").datepicker({
		defaultDate: "+1w",
		changeMonth: true,
		numberOfMonths: 1,
		showWeek: true,
		firstDay: 1,
		dateFormat: 'yy-mm-dd',
		onClose: function(selectedDate) {
			$("#to").datepicker("option", "minDate", selectedDate);
		}
	});
	$("#to").datepicker({
		defaultDate: "+1w",
		changeMonth: true,
		numberOfMonths: 1,
		showWeek: true,
		firstDay: 1,
		dateFormat: 'yy-mm-dd',
		onClose: function(selectedDate) {
			$("#from").datepicker("option", "maxDate", selectedDate);
		}
	});
	
	$('.sticky-enabled').tooltip({
		position: {
			my: "right center",
			at: "left-5 center",
		},
		show: {
			duration: "fast"
		},
		hide: {
			effect: "hide"
		},
		tooltipClass: "whitewallTip"
	});
	
	// ### DIALOG ###
	
	// NO RELATION ISSUES
	$('#noRel').click(function() {
		$("#relDialog").dialog({
			height: 400,
			width: 540,
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

	// DRAG X AXIS WAL
	// $("#wall table.sticky-enabled").draggable({ axis: "x", scroll: false, cursor: "move" });

	$('.hidden').hide(0);

	$('.postIt').on({
	    'click': function() {
			if($(this).hasClass('open')) {
	        	$(this).removeClass('open');
	            $(this).find('.hidden').slideToggle(200);
			} else {
	        	$(this).addClass('open');
	            $(this).find('.hidden').slideToggle(200);
			}
	    }
	});
	$('#showUsers div').on({
	    'click': function() {
			if($(this).parent().hasClass('open')) {
	        	$(this).parent().removeClass('open');
	            $(this).parent().find('ul').slideToggle(200);
			} else {
	        	$(this).parent().addClass('open');
	            $(this).parent().find('ul').slideToggle(200);
			}
	    }
	});
	$('#showUsers .invert b').click(function() {
		$('#showUsers li input').each(function() {
			var val = $(this).attr('checked');
			if(val == 'checked') {
				$(this).removeAttr('checked');
			} else {
				$(this).attr('checked','checked');
			}
		});
	});

	$('.tracker').click(function() {
		var trackerId = $(this).attr('id');
		if($(this).hasClass('open')) {
        	$(this).removeClass('open');
            $('.' + trackerId).slideToggle(200);
		} else {
        	$(this).addClass('open');
			$('.' + trackerId).slideToggle(200);
		}
	});

});