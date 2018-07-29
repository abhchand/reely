$(document).ready(function() {
  $(".collections-card").on("click", ".collections-card__menu-toggle", function(e) {
    var card = $(this).parents(".collections-card");
    $(card).toggleClass("collections-card--menu-open");
  });
});
