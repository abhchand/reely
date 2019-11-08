import { openCollectionsDeleteModal } from './_delete_modal';
import { openCollectionsShareModal } from './_share_modal';

// Delete
$(document).ready(() => {
  $('.collections-show__action-bar').on('click', '.collections-show__action-bar-item--delete', () => {
    const dataId = $('.collections-show__action-bar').attr('data-id');
    const dataName = $('#collection_name').val();

    openCollectionsDeleteModal(dataId, dataName);
  });
});

// Share
$(document).ready(() => {
  $('.collections-show__action-bar').on('click', '.collections-show__action-bar-item--share', () => {
    const dataId = $('.collections-show__action-bar').attr('data-id');
    const dataName = $('#collection_name').val();

    openCollectionsShareModal(dataId, dataName);
  });
});
