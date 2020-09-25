import { openModal } from 'javascript/components/modal/open';
import ProductFeedbackForm from 'javascript/components/product_feedback_form';
import React from 'react';

// eslint-disable-next-line padded-blocks
$(document).ready(() => {
  /*
   *
   * Product Feedback Link
   *
   */
  $('.desktop-navigation__link-element--product-feedback').on(
    'click',
    'a',
    (e) => {
      e.preventDefault();
      openModal(<ProductFeedbackForm />);
    }
  );
});
