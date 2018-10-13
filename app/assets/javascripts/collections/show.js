$(document).ready(function() {
  $(".collections-show__action-bar").on("click", ".collections-show__action-bar-item--delete", function(e) {
    var dataId = $(".collections-show__action-bar").attr("data-id");
    var dataName = $("#collection_name").val();

    openCollectionsDeleteModal(dataId, dataName);
  });
});
