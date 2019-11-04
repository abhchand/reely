import {openCollectionsDeleteModal} from "./_delete_modal";
import {openCollectionsShareModal} from "./_share_modal";

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
      const card = $(e.currentTarget).parents(".collections-card");
      $(card).addClass("collections-card--menu-open");
    }
  });

  // Delete
  $(".collections-card").on("click", ".collections-card__menu-item--delete", function() {
    const card = $(this).parents(".collections-card");

    const dataId = $(card).attr("data-id");
    const dataName = $(card).attr("data-name");

    openCollectionsDeleteModal(dataId, dataName);
  });

  // Share
  $(".collections-card").on("click", ".collections-card__menu-item--share", function() {
    const card = $(this).parents(".collections-card");

    const dataId = $(card).attr("data-id");
    const dataName = $(card).attr("data-name");

    openCollectionsShareModal(dataId, dataName);
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

