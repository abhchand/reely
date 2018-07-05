$(document).ready(function() {
  //
  // When expanded state is clicked -> collapse
  //
  $(".desktop-navigation__collapser").on("click", ".desktop-navigation__collapser--expanded", function(e) {
    e.preventDefault();

    var nav = $(".desktop-navigation");
    var expanded = $(".desktop-navigation__collapser--expanded");
    var collapsed = $(".desktop-navigation__collapser--collapsed");

    $(expanded).addClass("inactive");
    $(expanded).removeClass("active");

    $(collapsed).addClass("active");
    $(collapsed).removeClass("inactive");

    $(nav).addClass("collapsed");
  });

  //
  // When collapsed state is clicked -> expand
  //
  $(".desktop-navigation__collapser").on("click", ".desktop-navigation__collapser--collapsed", function(e) {
    e.preventDefault();

    var nav = $(".desktop-navigation");
    var expanded = $(".desktop-navigation__collapser--expanded");
    var collapsed = $(".desktop-navigation__collapser--collapsed");

    $(collapsed).addClass("inactive");
    $(collapsed).removeClass("active");

    $(expanded).addClass("active");
    $(expanded).removeClass("inactive");

    $(nav).removeClass("collapsed");
  });
});
