/* eslint-disable no-invalid-this */
/* eslint-disable func-names */
import { keyCodes, parseKeyCode } from 'javascript/utils/keys';
import DeleteCollection from 'javascript/components/delete_collection';
import { openModal } from 'javascript/components/modal/open';
import React from 'react';
import ShareCollection from 'javascript/components/share_collection';

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

    openModal(<DeleteCollection collection={{ id: dataId, name: dataName }} />);
  });

  // Share Collection Option
  $('.collections-card').on('click', '.collections-card__menu-item--share', function() {
    const card = $(this).parents('.collections-card');

    const dataId = $(card).attr('data-id');
    const dataName = $(card).attr('data-name');

    openModal(<ShareCollection collection={{ id: dataId, name: dataName }} />);
  });
});
