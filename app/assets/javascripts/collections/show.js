$(document).ready(function() {
  $(".collections-show__action-bar").on("click", ".collections-show__action-bar-item--delete", function(e) {
    var dataId = $(".collections-show__action-bar").attr("data-id");
    var dataName = $("#collection_name").text();

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
});
