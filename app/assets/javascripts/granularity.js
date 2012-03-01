$(document).ready(function() {

	function apply_granularity() {
		var granularity_minutes = parseInt($('#site_granularity_id option:selected').html());
		$(".timerow").each(function() {
			var slot_minutes = parseInt($(this).attr('id'));
			if(slot_minutes % granularity_minutes) {
				$(this).hide();
			} else {
				$(this).show();
			}
		});

		$('.timerow:visible:odd').css('background', '#f3f4f5');
		$('.timerow:visible:even').css('background', '#ffffff');
	}

	apply_granularity();
	$("#site_granularity_id").on("change", apply_granularity);

});
