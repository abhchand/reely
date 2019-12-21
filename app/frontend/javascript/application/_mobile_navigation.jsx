import { openModal } from 'javascript/components/modal/open';
import ProductFeedbackForm from 'javascript/components/product_feedback_form';
import React from 'react';

// eslint-disable-next-line padded-blocks
$(document).ready(() => {

  function toggleMobileMenu() {
    const mobileDropdownEl = $('.mobile-navigation');
    const overlayEl = $('.mobile-navigation__overlay');

    if ($(mobileDropdownEl).hasClass('active')) {
      // Disable menu
      $(mobileDropdownEl).removeClass('active');
      $(mobileDropdownEl).addClass('inactive');
      $(overlayEl).removeClass('active');
      $(overlayEl).addClass('inactive');
    }
    else {
      // Enable menu
      $(mobileDropdownEl).removeClass('inactive');
      $(mobileDropdownEl).addClass('active');
      $(overlayEl).removeClass('inactive');
      $(overlayEl).addClass('active');
    }
  }

  /*
   *
   * Open mobile menu
   *
   */
  $('.mobile-header').on('click', '.mobile-header__menu-icon', (e) => {
    e.preventDefault();
    toggleMobileMenu();
  });

  /*
   *
   * Close mobile menu
   *
   */
  $('.mobile-navigation').on('click', '.mobile-navigation__close', (e) => {
    e.preventDefault();
    toggleMobileMenu();
  });

  /*
   *
   * Overlay
   *
   */
  $('body').on('click', '.mobile-navigation__overlay', (e) => {
    e.preventDefault();
    toggleMobileMenu();
  });

  /*
   *
   * Product Feedback Link
   *
   */
  $('.mobile-navigation__link-element--product-feedback').on('click', 'a', (e) => {
    e.preventDefault();

    // Close the mobile menu to move it out of the way
    toggleMobileMenu();

    openModal(<ProductFeedbackForm />);
  });
});
