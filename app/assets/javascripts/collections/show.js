$(document).ready(function() {
  $(".collections-show__action-bar").on("click", ".collections-show__action-bar-item--delete", function(e) {
    // Add data-id to modal
    var dataId = $(".collections-show__action-bar").attr("data-id");
    $(".modal").attr("data-id", dataId);

    // Open modal
    $(".modal").addClass("active");
  });
});
