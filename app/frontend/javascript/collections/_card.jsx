/* eslint-disable no-invalid-this */
/* eslint-disable func-names */
import { keyCodes, parseKeyCode } from 'javascript/utils/keys';
import DeleteCollectionModal from 'javascript/collections/delete_modal';
import { openModal } from 'javascript/components/modal/open';
import React from 'react';
import ShareCollectionModal from 'javascript/collections/share_modal';

$(document).ready(() => {
  function closeAllMenus() {
    $('.collections-card--menu-open').each(function() {
      $(this).removeClass('collections-card--menu-open');
    });
  }

  // Open Card Menu
  $('.collections-card').on('click', '.collections-card__menu-btn', (e) => {
    e.stopPropagation();

    closeAllMenus();

    if ($(e.currentTarget).hasClass('collections-card__menu-btn')) {
      const card = $(e.currentTarget).parents('.collections-card');
      $(card).addClass('collections-card--menu-open');
    }
  });

  // Close Card Menu (Click)
  $('body#collections-index').click((e) => {
    const isClickOutsideCollectionsCardMenu = $(e.target).closest('.collections-card__menu').length === 0;
    if (isClickOutsideCollectionsCardMenu) { closeAllMenus(); }
  });

  // Close Card Menu (Keyboard)
  $('body#collections-index').keyup((e) => {
    if (parseKeyCode(e) === keyCodes.ESCAPE) { closeAllMenus(); }
  });

  // Delete Collection Option
  $('.collections-card').on('click', '.collections-card__menu-item--delete', function() {
    const card = $(this).parents('.collections-card');

    const dataId = $(card).attr('data-id');
    const dataName = $(card).attr('data-name');

    openModal(<DeleteCollectionModal collection={{ id: dataId, name: dataName }} />);
  });

  // Share Collection Option
  $('.collections-card').on('click', '.collections-card__menu-item--share', function() {
    const card = $(this).parents('.collections-card');

    const dataId = $(card).attr('data-id');
    const dataName = $(card).attr('data-name');

    openModal(<ShareCollectionModal collection={{ id: dataId, name: dataName }} />);
  });
});
