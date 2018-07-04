$(document).ready(function() {
  //
  // Close flash message
  //
  $("body").on("click", ".flash", function(e) {
    e.preventDefault();

    var flash = $(".flash");
    $(flash).removeClass("active");
    $(flash).addClass("inactive");
  });
});
