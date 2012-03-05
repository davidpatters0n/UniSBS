/*$(document).ready(function() {

	$(function() {
		$("#datepicker").datepicker({
			dateFormat : "DD, d MM, yy",
			onSelect : function(dateText, inst) {
				var newdate = new Date(dateText);
				var yyyy = newdate.getFullYear().toString();
				var mm = (newdate.getMonth() + 1).toString();
				var dd = newdate.getDate().toString();
				if(mm.length == 1) {
					mm = '0' + mm;
				}
				if(dd.length == 1) {
					dd = '0' + dd;
				}
				document.location.href = yyyy + '-' + mm + '-' + dd;
			}
		}).datepicker("setDate", new Date("<%= @slot_day.day %>"));
	});

	$("#today").button().click(function() {
		document.location.href = "<%= diary_url(@site) %>";
	});
}); */
