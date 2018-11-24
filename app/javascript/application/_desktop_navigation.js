$(document).ready(function() {
  $(".desktop-navigation").on("click", ".desktop-navigation__toggle", function(e) {
    e.preventDefault();

    var nav = $(".desktop-navigation");
    $(nav).toggleClass("desktop-navigation--collapsed");
  });
});
