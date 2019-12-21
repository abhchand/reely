import DeleteCollection from 'javascript/components/delete_collection';
import { openModal } from 'javascript/components/modal/open';
import React from 'react';
import ShareCollection from 'javascript/components/share_collection';

// Delete Collection Action
$(document).ready(() => {
  $('.collections-show__action-bar').on('click', '.collections-show__action-bar-item--delete', () => {
    const dataId = $('.collections-show__action-bar').attr('data-id');
    const dataName = $('#collection_name').val();

    openModal(<DeleteCollection collection={{ id: dataId, name: dataName }} />);
  });
});

// Share Collection Action
$(document).ready(() => {
  $('.collections-show__action-bar').on('click', '.collections-show__action-bar-item--share', () => {
    const dataId = $('.collections-show__action-bar').attr('data-id');
    const dataName = $('#collection_name').val();

    openModal(<ShareCollection collection={{ id: dataId, name: dataName }} />);
  });
});
