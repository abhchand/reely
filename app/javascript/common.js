// Expose JQuery globally
window.$ = window.jQuery = require("jquery");
require("jquery-ujs");

function openCollectionsDeleteModal(dataId, dataName) {
  // Add data-id to modal
  $(".modal").attr("data-id", dataId);

  // Set modal heading
  var heading = I18n.t("collections.delete_modal.heading", { collection_name: dataName });
  $(".modal .modal-content__heading").html(heading);

  // Open modal
  $(".modal").addClass("active");
};

export {openCollectionsDeleteModal};
