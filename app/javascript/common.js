// Expose JQuery globally
window.$ = window.jQuery = require("jquery");
require("jquery-ujs");

function openCollectionsDeleteModal(dataId, dataName) {
  // Add data-id to modal
  $(".collections-delete-modal").attr("data-id", dataId);

  // Set modal heading
  const heading = I18n.t("collections.delete_modal.heading", { collection_name: dataName });
  $(".collections-delete-modal .modal-content__heading").html(heading);

  // Open modal
  $(".collections-delete-modal").addClass("active");
}

function openCollectionsShareModal(dataId, dataName) {
  // Add data-id to modal
  $(".collections-share-modal").attr("data-id", dataId);

  // Open modal
  $(".collections-share-modal").addClass("active");
}

export {openCollectionsDeleteModal, openCollectionsShareModal};
