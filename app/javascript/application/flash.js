$(document).ready(() => {
  /*
   *
   * Close flash message
   *
   */
  $('body').on('click', '.flash', (e) => {
    e.preventDefault();

    const flash = $('.flash');
    $(flash).removeClass('active');
    $(flash).addClass('inactive');
  });
});
