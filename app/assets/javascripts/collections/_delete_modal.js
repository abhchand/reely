$(document).ready(function() {
  $(".collections-delete-modal").on("click", ".modal-content__button--submit", function(e) {

    // It is expected that whatever process opens the delete modal also sets the relevant
    // data-id attribute for use here
    var dataId = $(".modal").attr("data-id");

    // Disable submit
    $(e.target).prop("disabled", true);

    $.ajax({
      type: "DELETE",
      url: "/collections/" + dataId,
      dataType: "json",
      contentType: "application/json"
    })
      .fail(function() {
        // Re-enable submit
        e.prop("disabled", false);
      })
      .done(function() {
        // Redirect to index page
        window.location.href = "/collections";
      })
    ;
  });
});
