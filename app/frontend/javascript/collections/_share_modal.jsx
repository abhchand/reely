import React from 'react';
import ReactDOM from 'react-dom';
import ShareCollection from 'components/share_collection';

// Open
function openCollectionsShareModal(dataId, dataName) {
  const collection = { id: dataId, name: dataName };

  ReactDOM.render(
    <ShareCollection collection={collection} />,
    document.getElementById('collections-share-modal__component-container')
  );

  // Open modal
  $('.collections-share-modal').addClass('active');
}

// Close
$(document).ready(() => {
  $('.collections-share-modal').on('click', '.modal-content__button--close', () => {
    // Close modal
    $('.collections-share-modal').removeClass('active');

    /*
     * Unmount <ShareCollection /> component so it reloads for the
     * next collection
     */
    ReactDOM.unmountComponentAtNode(document.getElementById('collections-share-modal__component-container'));
  });
});

export { openCollectionsShareModal };
