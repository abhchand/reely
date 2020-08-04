// eslint-disable-next-line padded-blocks
$(document).ready(() => {

  /*
   *
   * Close flash message
   *
   */

  $('body').on('click', '.flash .close', (e) => {
    e.preventDefault();

    const flash = $('.flash');
    $(flash).removeClass('active');
    $(flash).addClass('inactive');
  });
});

// eslint-disable-next-line padded-blocks
function setFlash(type, text) {

  /*
   * Mimic the _flash.html.erb structure for active flashes
   *
   *  <div class="flash active error">
   *    <span class="message">Some text</span> <span class="close">Close</span>
   * </div>
   */

  const message = document.createElement('span');
  message.classList.add('message');
  message.innerText = text;

  const close = document.createElement('span');
  close.classList.add('close');
  close.innerText = I18n.t('layouts.flash.close');

  const flash = document.createElement('div');
  flash.classList.add('flash');
  flash.classList.add('active');
  flash.classList.add(type);
  flash.appendChild(message);
  flash.appendChild(close);

  // Replace existing flash with new flash
  const curFlash = document.querySelector('.flash');
  if (!curFlash) { return; }

  curFlash.replaceWith(flash);
}

export { setFlash };
