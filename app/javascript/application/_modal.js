$(document).ready(function() {
  $(".modal-content__button--cancel").click(function(e) {
    closeModal();
  });

  $(".modal-content__button--close").click(function(e) {
    closeModal();
  });

  $("body").on("keyup", function(e) {
    // Escape Key
    if (e.keyCode === 27 && $('.modal').is(':visible')) closeModal();
  });

  function closeModal() {
    // `data-id` is sometimes set on the modal when it opens
    // Remove it if it exists
    $(".modal").removeAttr("data-id");

    // Close the modal
    $(".modal").removeClass("active");
  }
});
