$(document).ready(function() {
  //
  // Open mobile menu
  //
  $(".mobile-header").on("click", ".mobile-header__menu-icon", function(e) {
    e.preventDefault();
    toggleMobileMenu();
  });

  //
  // Close mobile menu
  //
  $(".mobile-navigation").on("click", ".mobile-navigation__close", function(e) {
    e.preventDefault();
    toggleMobileMenu();
  });

  //
  // Overlay
  //
  $("body").on("click", ".mobile-navigation__overlay", function(e) {
    e.preventDefault();
    toggleMobileMenu();
  });

  function toggleMobileMenu() {
    const mobileDropdownEl = $(".mobile-navigation");
    const overlayEl = $(".mobile-navigation__overlay");

    if ($(mobileDropdownEl).hasClass("active")) {
      // Disable menu
      $(mobileDropdownEl).removeClass("active");
      $(mobileDropdownEl).addClass("inactive");
      $(overlayEl).removeClass("active");
      $(overlayEl).addClass("inactive");
    } else {
      // Enable menu
      $(mobileDropdownEl).removeClass("inactive");
      $(mobileDropdownEl).addClass("active");
      $(overlayEl).removeClass("inactive");
      $(overlayEl).addClass("active");
    }
  }
});
