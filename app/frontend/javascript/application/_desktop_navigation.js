import { openProductFeedbacksModal } from 'javascript/product_feedbacks/_create_modal';

// eslint-disable-next-line padded-blocks
$(document).ready(() => {

  /*
   *
   * Product Feedback Link
   *
   */
  $('.desktop-navigation__link-element--product-feedback').on('click', 'a', (e) => {
    e.preventDefault();
    openProductFeedbacksModal();
  });
});
