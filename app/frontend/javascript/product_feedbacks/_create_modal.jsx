import ProductFeedbackForm from 'javascript/components/product_feedback_form';
import React from 'react';
import ReactDOM from 'react-dom';

// Open
function openProductFeedbacksModal() {
  ReactDOM.render(
    <ProductFeedbackForm />,
    document.getElementById('product-feedbacks-create-modal__component-container')
  );

  // Open modal
  $('.product-feedbacks-create-modal').addClass('active');
}

// Close
$(document).ready(() => {
  $('.product-feedbacks-create-modal').on('click', '.modal-content__button--close', () => {
    // Close modal
    $('.product-feedbacks-create-modal').removeClass('active');

    /*
     * Unmount <ProductFeedbackForm /> component so it reloads for the
     * next collection
     */
    ReactDOM.unmountComponentAtNode(document.getElementById('product-feedbacks-create-modal__component-container'));
  });
});


export { openProductFeedbacksModal };
