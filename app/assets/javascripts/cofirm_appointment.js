 $(function() {
/*    $("#datepicker").datepicker({
      dateFormat: "DD, d MM, yy",
    }); */

    $("#confirm_appointment").button().click(function()
    {
      $("#confirm_appointment_dialog").dialog();
    });
  });