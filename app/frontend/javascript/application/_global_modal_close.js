import { keyCodes, parseKeyCode } from 'javascript/utils/keys';
import { closeModal } from 'javascript/components/modal/close';

$(document).ready(() => {
  $('body').on('keyup', (e) => {
    if (parseKeyCode(e) === keyCodes.ESCAPE && $('.modal').is(':visible')) {
      closeModal();
    }
  });
});
