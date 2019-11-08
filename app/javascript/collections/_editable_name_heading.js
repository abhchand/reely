$(document).ready(() => {
  let origCollectionName;
  let newCollectionName;

  $('.collections-editable-name-heading').on('focus', '.collections-editable-name-heading__textarea', (e) => {
    origCollectionName = e.target.value;
  });

  $('.collections-editable-name-heading').on('blur', '.collections-editable-name-heading__textarea', (e) => {
    updateCollectionName();
  });

  $('.collections-editable-name-heading__textarea').keydown((e) => {
    // Enter Key
    if (e.keyCode == 13) {
      e.preventDefault();
      e.target.blur();
    }

    // Escape Key
    if (e.keyCode === 27) {
      const textArea = $('.collections-editable-name-heading__textarea');
      textArea.val(origCollectionName);
      e.target.blur();
    }
  });

  function updateCollectionName() {
    const textArea = $('.collections-editable-name-heading__textarea');
    newCollectionName = textArea.val();

    // Blank string
    if (!newCollectionName || (/^\s*$/).test(newCollectionName)) {
      textArea.val(origCollectionName);
      return;
    }

    // No update
    if (origCollectionName == newCollectionName) {
      return;
    }

    /*
     * Remove confirmation in case it's still active
     * This does not remove the timer created by the existing confirmation, which will still
     * run at the scheduled time and clear the new confirmation earlier than intened.
     *
     *  -> confirmation #1
     *  -> confirmation #2
     *  -> Timer to clear confirmation #1  <--- Does not get cleared
     *  -> Timer to clear confirmation #2
     *
     * This is a race condition, but acceptable for now
     */
    disableConfirmation();

    $.ajax({
      type: 'PUT',
      url: `/collections/${textArea.attr('data-id')}`,
      data: JSON.stringify({ collection: { name: newCollectionName } }),
      dataType: 'json',
      contentType: 'application/json'
    }).
      fail(() => {
        // Reset textarea to original value
        textArea.val(origCollectionName);
      }).
      done(() => {
        // Update tracked name
        origCollectionName = newCollectionName;

        enableConfirmation();
        setTimeout(disableConfirmation, 1500);
      });
  }

  function enableConfirmation() {
    $('.collections-editable-name-heading__confirm').addClass('active');
  }

  function disableConfirmation() {
    $('.collections-editable-name-heading__confirm').removeClass('active');
  }
});
