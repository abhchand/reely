import ReactDOM from 'react-dom';

// eslint-disable-next-line padded-blocks
function closeModal() {
  /*
   * `data-id` is sometimes set on the modal when it opens
   * Remove it if it exists
   */
  $('.modal').removeAttr('data-id');

  // Unmount modal component
  ReactDOM.unmountComponentAtNode(document.getElementById('modal'));
}

export { closeModal };
