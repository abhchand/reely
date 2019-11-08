function openCollectionsDeleteModal(dataId, dataName) {
  // Add data-id to modal
  $('.collections-delete-modal').attr('data-id', dataId);

  // Set modal heading
  const heading = I18n.t('collections.delete_modal.heading', { collection_name: dataName });
  $('.collections-delete-modal .modal-content__heading').html(heading);

  // Open modal
  $('.collections-delete-modal').addClass('active');
}

$(document).ready(() => {
  $('.collections-delete-modal').on('click', '.modal-content__button--submit', (e) => {

    /*
     * It is expected that whatever process opens the delete modal also
     * sets the relevant data-id attribute for use here
     */
    const dataId = $('.collections-delete-modal').attr('data-id');

    // Disable submit
    $(e.target).prop('disabled', true);

    $.ajax({
      type: 'DELETE',
      url: `/collections/${dataId}`,
      dataType: 'json',
      contentType: 'application/json'
    }).
      fail(() => {
        // Re-enable submit
        e.prop('disabled', false);
      }).
      done(() => {
        // Redirect to index page
        window.location.href = '/collections';
      });
  });
});

export { openCollectionsDeleteModal };
