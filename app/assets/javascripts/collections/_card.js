$(document).ready(function() {
  $("body#collections-index").click(function(e) {
    if (isClickOutsideCollectionsCardMenu(e)) {
      closeAllMenus();
    }
  });

  $("body#collections-index").keyup(function(e) {
    // Escape Key
    if (e.keyCode === 27) closeAllMenus();
  });

  $(".collections-card").on("click", ".collections-card__menu-btn", function(e) {
    e.stopPropagation();

    closeAllMenus();

    if ($(this).hasClass("collections-card__menu-btn")) {
      var card = $(this).parents(".collections-card");
      $(card).addClass("collections-card--menu-open");
    }
  });

  function closeAllMenus() {
    $(".collections-card--menu-open").each(function() {
      $(this).removeClass("collections-card--menu-open");
    });
  }

  function isClickOutsideCollectionsCardMenu(e) {
    return $(e.target).closest(".collections-card__menu").length === 0;
  }
});
