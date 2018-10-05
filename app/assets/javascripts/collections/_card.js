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

    if ($(e.currentTarget).hasClass("collections-card__menu-btn")) {
      var card = $(e.currentTarget).parents(".collections-card");
      $(card).addClass("collections-card--menu-open");
    }
  });

  $(".collections-card").on("click", ".collections-card__menu-item--delete", function(e) {
    var card = $(this).parents(".collections-card");
    var dataId = $(card).attr("data-id");
    var dataName = $(card).attr("data-name");

    //
    // TODO: Move this to a common "open modal" function
    //

    // Add data-id to modal
    $(".modal").attr("data-id", dataId);

    // Set modal heading
    var heading = I18n.t("collections.delete_modal.heading", { collection_name: dataName });
    $(".modal .modal-content__heading").html(heading);

    // Open modal
    $(".modal").addClass("active");
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

